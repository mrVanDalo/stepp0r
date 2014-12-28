--- ======================================================================================================
---
---                                                 [ Effect Panning ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Chooser:__init_effect_panning()
end
function Chooser:__activate_effect_panning()
end
function Chooser:__deactivate_effect_panning()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

--- transforms key number to paning
-- number must be 0-8
function xToPan(number)
    if number < 1 or number > 8 then return 255 end
    if number < 5 then
        return 64 - (16 * (5 - number))
    else
        return 64 + (16 * (number - 4))
    end
end

function Effect:set_pan(pan)
    if self.pan == pan then self.pan = 0
    else self.pan = pan
    end
    self:matrix_refresh()
    -- trigger callbacks
    local percent = xToPan(self.pan)
    for _, callback in ipairs(self.callbacks_set_pan) do
        callback(percent)
    end
end

function Effect:matrix_update_pan()
    if self.pan == 0 then return end
    local on  = self:mode_color()
    local off = self.color.off
    if self.pan < 5 then
        for i = 1, 4 do
            local color = on
            if self.pan > i then color = off end
            self.pad:set_matrix(i,self.row,color)
        end
    else
        for i = 5, 8 do
            local color = on
            if self.pan < i then color = off end
            self.pad:set_matrix(i,self.row,color)
        end
    end
end

