--- ======================================================================================================
---
---                                                 [ Effect mode ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Effect:__init_effect_mode()
    self.mode          = EffectData.mode.DELAY
    self.mode_knob_idx = self.row
    self:__create_mode_listener()
end
function Effect:__activate_effect_mode()
    self.pad:register_side_listener(self.mode_listener)
end
function Effect:__deactivate_effect_mode()
    self.pad:set_side(self.mode_knob_idx,Color.off)
    self.pad:unregister_side_listener(self.mode_listener)
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Effect:__create_mode_listener()
    self.mode_listener = function (_,msg)
        if self.is_not_active          then return end
        if msg.vel == Velocity.release then return end
        if msg.x ~= self.mode_knob_idx then return end
        self:next_mode()
    end
end

function Effect:next_mode()
    if     self.mode == EffectData.mode.DELAY then self.mode = EffectData.mode.PAN
    elseif self.mode == EffectData.mode.PAN   then self.mode = EffectData.mode.VOLUME
    else                                           self.mode = EffectData.mode.DELAY    end
    self:_refresh_mode_knob()
    self:_refresh_effect_row()
end

function Effect:mode_color()
    return self.mode[EffectData.access.color]
end

function Effect:_refresh_mode_knob()
    self.pad:set_side(self.mode_knob_idx,self:mode_color())
end


