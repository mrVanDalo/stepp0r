--- ======================================================================================================
---
---                                                 [ Editor Module ]
---
--- stepp the pattern

class "Editor" (Module)

require "Module/Editor/EditorRender"
require "Module/Editor/EditorCallbacks"

EditorData = {
    note = {
        off   = 120,
        empty = 121,
    },
    instrument = { empty = 255 },
    delay      = { empty = 0 },
    volume     = { empty = 255 },
    panning    = { empty = 255 },
    color = {
        clear = Color.off
    }
}

--- ======================================================================================================
---
---                                                 [ INIT ]

function Editor:__init()
    Module:__init(self)
    self.track_idx       = 1
    self.instrument_idx  = 1
    self.note        = Note.note.c
    self.octave      = 4
    self.delay       = 0
    self.volume      = EditorData.instrument.empty
    self.pan         = EditorData.instrument.empty
    -- ---
    -- navigation
    -- ---
    -- zoom
    self.zoom         = 1 -- influences grid size
    -- pagination
    self.page         = 1 -- page of actual pattern
    self.page_start   = 0  -- line left before first pixel
    self.page_end     = 33 -- line right after last pixel
    -- rest
    self.track_column_idx = 1 -- the column in the track
    self.pattern_idx      = 1 -- actual pattern
    -- rendering
    self.matrix      = {}
    self.color       = {
        stepper = Color.green,
        page = {
            active   = Color.yellow,
            inactive = Color.off,
        },
        zoom = {
            active   = Color.yellow,
            inactive = Color.off,
        },
        note = {
            off   = Color.red,
            on    = Color.yellow,
            empty = Color.off,
        },
    }
    self.playback_position_observer = nil
    self.playback_position_last_x = 1
    self.playback_position_last_y = 1
    self:__create_callbacks()

    self:__init_launchpad_matrix()
    self:__init_library()
    self:__init_playback_position()
end

function Editor:_activate()
    self:__activate_launchpad_matrix()
    self:__activate_library()
    self:__activate_playback_position()

    self:_refresh_matrix()
end

function Editor:_deactivate()
    self:__deactivate_launchpad_matrix()
    self:__deactivate_library()
    self:__deactivate_playback_position()

    self:__matrix_clear()
end


function Editor:wire_launchpad(pad)
    self.pad = pad
end

function Editor:wire_playback_position_observer(playback_position_observer)
    if self.playback_position_observer then
        self:__unregister_playback_position_observer()
    end
    self.playback_position_observer = playback_position_observer
end



--- ======================================================================================================
---
---                                                 [ Library ]


function Editor:_refresh_matrix()
    self:__matrix_clear()
    self:__matrix_update()
    self:__render_matrix()
end

--- get the active pattern object
--
-- self.pattern_idx will be kept up to date by an observable notifier
--
function Editor:active_pattern()
    return renoise.song().patterns[self.pattern_idx]
end


--- calculates the position in track
--
-- the point should come from the launchpad.
-- the note_column that is selected will be taken in account
--
-- @return nil if nothing found
--
function Editor:calculate_track_position(x,y)
    local line       = self:point_to_line(x,y)
    local pattern    = self:active_pattern()
    local found_line = pattern.tracks[self.track_idx].lines[line]
    if found_line then
        return found_line.note_columns[self.track_column_idx]
    else
        return nil
    end
end

