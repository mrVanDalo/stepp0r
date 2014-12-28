
--- ======================================================================================================
---
---                                                 [ Effect Instrument Callback ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Chooser:__init_effect_instrument()
    self:__create_callback_set_instrument()
end
function Chooser:__activate_effect_instrument()
    self.pad:register_matrix_listener(self.matrix_listener)
end
function Chooser:__deactivate_effect_instrument()
    self.pad:unregister_matrix_listener(self.matrix_listener)
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Effect:__create_callback_set_instrument()
    self.callback_set_instrument = function (_,_,_)
        if self.is_not_active then return end
        self:set_delay(1)
        self:set_volume(1)
        self:set_pan(0)
    end
end
