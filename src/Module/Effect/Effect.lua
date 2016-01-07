--- ======================================================================================================
---
---                                                 [ Effect Module ]

--- updaten an manage Effect information


class "Effect" (Module)

require "Module/Effect/EffectDelay"
require "Module/Effect/EffectInstrumentCallback"
require "Module/Effect/EffectVolume"
require "Module/Effect/EffectPanning"
require "Module/Effect/EffectMode"


EffectData = {
    mode = {
        DELAY  = {3, NewColor[0][3] },
        PAN    = {2, NewColor[3][3] },
        VOLUME = {1, NewColor[3][0] },
    },
    color = NewColor[0][3],
    access = {
        color = 2,
    }
}

--- ======================================================================================================
---
---                                                 [ INIT ]

function Effect:__init()
    Module:__init(self)

    self.row           = 5

    self.color = {
        on  = NewColor[3][2],
        off = Color.off,
    }

    self:__init_effect_delay()
    self:__init_effect_mode()
    self:__init_effect_panning()
    self:__init_effect_volume()
    self:__init_effect_instrument()

    -- (maybe) todo split this thing
    self:__create_matrix_listener()
end

function Effect:_activate()
    self:__activate_effect_delay()
    self:__activate_effect_mode()
    self:__activate_effect_panning()
    self:__activate_effect_volume()
    self:__activate_effect_instrument()
    self:refresh()
end

function Effect:_deactivate()
    self:__deactivate_effect_delay()
    self:__deactivate_effect_mode()
    self:__deactivate_effect_panning()
    self:__deactivate_effect_volume()
    self:__deactivate_effect_instrument()
    self:matrix_clear()
end

function Effect:wire_launchpad(pad)
    self.pad = pad
end

--- register a listener on the set delay
-- callbacks will receive a number 0-255
-- 0 is empty
function Effect:register_set_delay(callback)
    table.insert(self.callbacks_set_delay,callback)
end
--- register a listener on the set pan
-- callbacks will receive a number 0-127
-- 255 is empty
-- 64 is the center
function Effect:register_set_pan(callback)
    table.insert(self.callbacks_set_pan,callback)
end
--- register a listener on the set volume
-- callbacks will receive a number 0-127
-- 255 is empty
function Effect:register_set_volume(callback)
    table.insert(self.callbacks_set_volume,callback)
end

function Effect:__create_matrix_listener()
    --- split in more than one listener and exit early
    self.matrix_listener = function (_,msg)
        if self.is_not_active          then return end
        if msg.vel == Velocity.release then return end
        if msg.y ~= self.row           then return end
        if     self.mode == EffectData.mode.DELAY  then self:_set_delay(msg.x)
        elseif self.mode == EffectData.mode.VOLUME then self:_set_volume(msg.x)
        else                                            self:_set_pan(msg.x)
        end
    end
end





--- ======================================================================================================
---
---                                                 [ Rendering ]

function Effect:matrix_clear()
    for i = 1, 8 do
        self.pad:set_matrix(i, self.row,self.color.off)
    end
end

function Effect:_refresh_effect_row()
    self:matrix_clear()
    if self.mode == EffectData.mode.DELAY then
        self:_update_delay_row()
    elseif self.mode == EffectData.mode.PAN then
        self:_update_paning_row()
    else
        self:_update_volume_row()
    end
end

function Effect:refresh()
    self:_refresh_effect_row()
    self:_refresh_mode_knob()
end

