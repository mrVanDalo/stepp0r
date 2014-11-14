
--- transforms key number to percentage
-- number must be 1-8

function xToDelay(number)
    if (number < 2 ) then return 0 end
    if (number > 8 ) then return 0 end
    -- return ((256 / 8) * (number - 1) - 1)
    return (256 / 8) * (number - 1)
end

function Effect:set_delay(delay)
    self.delay = delay
    self:matrix_refresh()
    -- trigger callbacks
    local percent = xToDelay(self.delay)
    for _, callback in ipairs(self.callbacks_set_delay) do
        callback(percent)
    end
end

--- update matrix with the delay information
function Effect:matrix_update_delay()
    local on  = self:mode_color()
    self.pad:set_matrix(self.delay,self.row,on)
end
