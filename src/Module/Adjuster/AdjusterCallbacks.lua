
function Adjuster:_create_callbacks()
    self:__create_bank_update_handler()
end

function Adjuster:__create_bank_update_handler()
    self.bank_update_handler = function (bank, mode)
        self.bank     = bank
        self.mode     = mode
        self:_refresh_matrix()
    end
end

--- updates the point that should blink on the launchpad
--
-- will be hooked in by the playback_position observable
--
function Adjuster:callback_playback_position(pos)
    if self.pattern_idx ~= pos.sequence then return end
    -- clean up old playback position
    if (self.removed_old_playback_position) then
        self:__render_matrix_position(
            self.playback_position_last_x,
            self.playback_position_last_y
        )
        self.removed_old_playback_position = nil
    end
    -- update position
    local line = pos.line
    if (line <= self.page_start) then return end
    if (line >= self.page_end)   then return end
    local xy = self:line_to_point(line)
    if not xy then return end
    -- set playback position
    local x = xy[1]
    local y = xy[2]
    self.pad:set_matrix(x,y,self.color.stepper)
    self.playback_position_last_x = x
    self.playback_position_last_y = y
    self.removed_old_playback_position = true
end

function Adjuster:callback_set_instrument()
    return function (instrument_idx, track_idx, column_idx)
        self.track_idx        = track_idx
        self.track_column_idx = column_idx
        self.instrument_idx   = instrument_idx
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end

function Adjuster:callback_set_note()
    return function (note,octave)
        if self.is_not_active then return end
        self.note   = note
        self.octave = octave
    end
end

function Adjuster:callback_set_delay()
    return function() end
    -- todo does nothing yet
    --    return function (delay)
    --        if self.is_not_active then return end
    --        self.delay = delay
    --    end
end

function Adjuster:callback_set_volume()
    return function() end
    -- todo does nothing yet
    --    return function (volume)
    --        if self.is_not_active then return end
    --        self.volume = volume
    --    end
end

function Adjuster:callback_set_pan()
    return function() end
    -- todo does nothing yet
    --    return function (pan)
    --        if self.is_not_active then return end
    --        self.pan = pan
    --    end
end

function Adjuster:callback_set_bank()
    return function () end
    -- todo write me
end
