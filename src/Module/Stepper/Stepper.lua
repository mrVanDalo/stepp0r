--- ======================================================================================================
---
---                                                 [ Stepper Module ]
---
--- stepp the pattern

class "Stepper" (Module)

require "Module/Stepper/StepperRender"
require "Module/Stepper/StepperCallbacks"

StepperData = {
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

function Stepper:__init()
    Module:__init(self)
    self.track_idx       = 1
    self.instrument_idx  = 1
    self.note        = Note.note.c
    self.octave      = 4
    self.delay       = 0
    self.volume      = StepperData.instrument.empty
    self.pan         = StepperData.instrument.empty
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
end

function Stepper:wire_launchpad(pad)
    self.pad = pad
end

function Stepper:wire_playback_position_observer(playback_position_observer)
    if self.playback_position_observer then
        self:__unregister_playback_position_observer()
    end
    self.playback_position_observer = playback_position_observer
end


--- ======================================================================================================
---
---                                                 [ BooT ]

function Stepper:_activate()
    self.pattern_idx = renoise.song().selected_pattern_index
    add_notifier(renoise.song().selected_pattern_index_observable,self.selected_pattern_index_notifier)
    self.pad:register_matrix_listener(self.pattern_matrix_listener)
    self:__register_playback_position_observer()
    self:_refresh_matrix()
end

function Stepper:_deactivate()
    self:__matrix_clear()
    self:__render_matrix()
    remove_notifier(renoise.song().selected_pattern_index_observable,self.selected_pattern_index_notifier)
    self.pad:unregister_matrix_listener(self.pattern_matrix_listener)
    self:__unregister_playback_position_observer()
end

function Stepper:__register_playback_position_observer()
    self.playback_position_observer:register('stepper', function (line)
        if self.is_not_active then return end
        self:callback_playback_position(line)
    end)
end

function Stepper:__unregister_playback_position_observer()
    self.playback_position_observer:unregister('stepper' )
end













--- ======================================================================================================
---
---                                                 [ Library ]

--- calculate point (for matrix) of line
--
-- nil for is not on the matrix
--
function Stepper:line_to_point(line)
    -- page
    local l = line - self.page_start
    if l < 1 then return end
    -- zoom
    local li = l
    if (self.zoom > 1) then
        if ((l - 1) % self.zoom) ~= 0 then return end
        li = ((l - 1) / self.zoom) + 1
    end
    -- transformation
    local x = ((li - 1) % 8) + 1
    local y = math.floor((li - 1) / 8) + 1
    return {x,y}
end

--- calculate the line a point given by the actual matrix configuration
--
-- point_to_line(line_to_point(l)) == l should allways be true ?
--
function Stepper:point_to_line(x,y)
    return ((x + (8 * (y - 1))) - 1) * self.zoom + 1 + self.page_start
end

function Stepper:_refresh_matrix()
    self:__matrix_clear()
    self:__matrix_update()
    self:__render_matrix()
end

--- get the active pattern object
--
-- self.pattern_idx will be kept up to date by an observable notifier
--
function Stepper:active_pattern()
    return renoise.song().patterns[self.pattern_idx]
end


--- calculates the position in track
--
-- the point should come from the launchpad.
-- the note_column that is selected will be taken in account
--
-- @return nil if nothing found
--
function Stepper:calculate_track_position(x,y)
    local line       = self:point_to_line(x,y)
    local pattern    = self:active_pattern()
    local found_line = pattern.tracks[self.track_idx].lines[line]
    if found_line then
        return found_line.note_columns[self.track_column_idx]
    else
        return nil
    end
end

