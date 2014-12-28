--- ======================================================================================================
---
---                                                 [ Effect mode ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Chooser:__init_effect_mode()
end
function Chooser:__activate_effect_mode()
end
function Chooser:__deactivate_effect_mode()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Effect:next_mode()
    if     self.mode == EffectData.mode.DELAY then self.mode = EffectData.mode.PAN
    elseif self.mode == EffectData.mode.PAN   then self.mode = EffectData.mode.VOLUME
    else                                           self.mode = EffectData.mode.DELAY    end
    self:right_refresh()
    self:matrix_refresh()
end

function Effect:mode_color()
    return self.mode[EffectData.access.color]
end

function Effect:right_refresh()
    self.pad:set_side(self.mode_knob_idx,self:mode_color())
end


