
function Adjuster:_create_callbacks()
    self:__create_paginator_update()

    self:__create_callback_set_instrument()
    self:__create_callback_set_note()
    self:__create_callback_set_delay()
    self:__create_callback_set_volume()
    self:__create_callback_set_pan()
    self:__create_callback_set_bank()
end

function Adjuster:__create_bank_update_handler()
    self.bank_update_handler = function (bank, mode)
        self.bank     = bank
        self.mode     = mode
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end

function Adjuster:__create_paginator_update()
    self.pageinator_update_callback = function (msg)
--        print("adjuster : update paginator")
        self.page       = msg.page
        self.page_start = msg.page_start
        self.page_end   = msg.page_end
        self.zoom       = msg.zoom
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end

function Adjuster:__create_callback_set_instrument()
    self.callback_set_instrument =  function (instrument_idx, track_idx, column_idx)
        self.track_idx        = track_idx
        self.track_column_idx = column_idx
        self.instrument_idx   = instrument_idx
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end

function Adjuster:__create_callback_set_note()
    self.callback_set_note =  function (note,octave)
        self.note   = note
        self.octave = octave
    end
end

function Adjuster:__create_callback_set_delay()
    self.callback_set_delay =  function() end
end

function Adjuster:__create_callback_set_volume()
    self.callback_set_volume =  function() end
end

function Adjuster:__create_callback_set_pan()
    self.callback_set_pan =  function() end
end

function Adjuster:__create_callback_set_bank()
    self.callback_set_bank = function () end
end

