
function Stepper:__create_callbacks()
    self:__create_set_instrument_callback()
    self:__create_paginator_update()
    self:__create_callback_set_note()
    self:__create_callback_set_delay()
    self:__create_callback_set_volume()
    self:__create_callback_set_pan()
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
