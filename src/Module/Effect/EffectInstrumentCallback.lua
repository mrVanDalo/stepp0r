
--- ======================================================================================================
---
---                                                 [ Effect Instrument Callback ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Effect:__init_effect_instrument()
    self:__create_callback_set_instrument()
end
function Effect:__activate_effect_instrument()
    self.pad:register_matrix_listener(self.matrix_listener)
end
function Effect:__deactivate_effect_instrument()
    self.pad:unregister_matrix_listener(self.matrix_listener)
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Effect:__create_callback_set_instrument()
    self.callback_set_instrument = function (_,_,_)
        if self.is_not_active then return end
        self:_set_delay(1)
        self:_set_volume(1)
        self:_set_pan(0)
    end
end
