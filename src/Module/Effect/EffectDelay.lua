
--- ======================================================================================================
---
---                                                 [ Effect Delay]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Effect:__init_effect_delay()
    self.delay                = 1 -- init values
    self.callbacks_set_delay  = {}
end
function Effect:__activate_effect_delay()
end
function Effect:__deactivate_effect_delay()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

--- transforms key number to percentage
-- number must be 1-8

function xToDelay(number)
    if (number < 2 ) then return 0 end
    if (number > 8 ) then return 0 end
    -- return ((256 / 8) * (number - 1) - 1)
    return (256 / 8) * (number - 1)
end

function Effect:_set_delay(delay)
    self.delay = delay
    self:_refresh_effect_row()
    -- trigger callbacks
    local percent = xToDelay(self.delay)
    for _, callback in ipairs(self.callbacks_set_delay) do
        callback(percent)
    end
end

--- update matrix with the delay information
function Effect:_update_delay_row()
    local on  = self:mode_color()
    self.pad:set_matrix(self.delay,self.row,on)
end
