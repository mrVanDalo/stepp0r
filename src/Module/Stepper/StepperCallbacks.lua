
function Stepper:__create_callbacks()
    self:__create_set_instrument_callback()
    self:__create_paginator_update()
    self:__create_callback_set_note()
    self:__create_callback_set_delay()
    self:__create_callback_set_volume()
    self:__create_callback_set_pan()
    self:__create_selected_pattern_index_notifier()
    self:__create_pattern_matrix_listener()
end

function Stepper:__create_selected_pattern_index_notifier()
    self.selected_pattern_index_notifier = function (_)
        self.pattern_idx = renoise.song().selected_pattern_index
        if self.is_not_active then return end
        self:_refresh_matrix()
    end
end

function Stepper:__create_pattern_matrix_listener()
    self.pattern_matrix_listener = function (_,msg)
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
    end
end

function Stepper:__create_paginator_update()
    self.pageinator_update_callback = function (msg)
    --        print("stepper : update paginator")
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
    self.callback_set_instrument = function (instrument_idx, track_idx, column_idx)
        self.track_idx        = track_idx
        self.track_column_idx = column_idx
        self.instrument_idx   = instrument_idx
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end

function Stepper:__create_callback_set_note()
    self.callback_set_note =  function (note,octave)
        self.note   = note
        self.octave = octave
    end
end

function Stepper:__create_callback_set_delay()
    self.callback_set_delay =  function (delay)
        self.delay = delay
    end
end
function Stepper:__create_callback_set_volume()
    self.callback_set_volume = function (volume)
        self.volume = volume
    end
end
function Stepper:__create_callback_set_pan()
    self.callback_set_pan =  function (pan)
        self.pan = pan
    end
end
