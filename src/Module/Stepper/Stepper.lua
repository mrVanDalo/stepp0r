--- ======================================================================================================
---
---                                                 [ Stepper Module ]
---
--- stepp the pattern

class "Stepper" (Module)

require "Module/Stepper/StepperRender"

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
        self:unregister_playback_position_observer()
    end
    self.playback_position_observer = playback_position_observer
end


function Stepper:__create_callbacks()
    self:__create_set_instrument_callback()
    self:__create_paginator_update()
end

function Stepper:__create_paginator_update()
    self.pageinator_update_callback = function (msg)
        print("stepper : update paginator")
        self.page       = msg.page
        self.page_start = msg.page_start
        self.page_end   = msg.page_end
        self.zoom       = msg.zoom
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end

function Stepper:__create_set_instrument_callback()
    self.set_instrument_callback = function (instrument_idx, track_idx, column_idx)
        self.track_idx        = track_idx
        self.track_column_idx = column_idx
        self.instrument_idx   = instrument_idx
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end



function Stepper:callback_set_note()
    return function (note,octave)
        self.note   = note
        self.octave = octave
    end
end

function Stepper:callback_set_delay()
    return function (delay)
        self.delay = delay
    end
end
function Stepper:callback_set_volume()
    return function (volume)
        self.volume = volume
    end
end
function Stepper:callback_set_pan()
    return function (pan)
        self.pan = pan
    end
end












--- ======================================================================================================
---
---                                                 [ BooT ]

function Stepper:_activate()

    --- selected pattern changes
    --
    -- deprecated ?
    self.pattern_idx = renoise.song().selected_pattern_index
    if self.is_first_run then
        renoise.song().selected_pattern_index_observable:add_notifier(function (_)
            if self.is_not_active then return end
            self.pattern_idx = renoise.song().selected_pattern_index
            self:_refresh_matrix()
        end)
    end

    --- selected playback position
    --
    -- the green light that runs
    --
    self:register_playback_position_observer()


    --- pad matrix listener
    --
    -- listens on click events on the launchpad matrix
    if self.is_first_run then
        self.pad:register_matrix_listener(function (_,msg)
            if self.is_not_active          then return end
            if msg.vel == Velocity.release then return end
            if msg.y > 4                   then return end
            local column           = self:calculate_track_position(msg.x,msg.y)
            if not column then return end
            if column.note_value == StepperData.note.empty then
                column.note_value         = pitch(self.note,self.octave)
                column.instrument_value   = (self.instrument_idx - 1)
                column.delay_value        = self.delay
                column.panning_value      = self.pan
                column.volume_value       = self.volume
                if column.note_value == StepperData.note.off then
                    self.matrix[msg.x][msg.y] = self.color.note.off
                else
                    self.matrix[msg.x][msg.y] = self.color.note.on
                end
            else
                column.note_value         = StepperData.note.empty
                column.instrument_value   = StepperData.instrument.empty
                column.delay_value        = StepperData.delay.empty
                column.panning_value      = StepperData.panning.empty
                column.volume_value       = StepperData.volume.empty
                self.matrix[msg.x][msg.y] = self.color.note.empty
            end
            self.pad:set_matrix(msg.x,msg.y,self.matrix[msg.x][msg.y])
        end)
    end

    --- refresh the matrix
    self:_refresh_matrix()
end

function Stepper:register_playback_position_observer()
    self.playback_position_observer:register('stepper', function (line)
        if self.is_not_active then return end
        self:callback_playback_position(line)
    end)
end

function Stepper:unregister_playback_position_observer()
    self.playback_position_observer:unregister('stepper' )
end

--- tear down
--
function Stepper:_deactivate()
    self:__matrix_clear()
    self:__render_matrix()
    self:unregister_playback_position_observer()
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

