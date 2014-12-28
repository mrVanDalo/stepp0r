

--- ======================================================================================================
---
---                                                 [ Keyboard Instrument Callback ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Keyboard:__init_keyboard_instrument_callback()
    self:__create_callback_set_instrument()
end
function Keyboard:__activate_keyboard_instrument_callback()
end
function Keyboard:__deactivate_keyboard_instrument_callback()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Keyboard:__create_callback_set_instrument()
    self.callback_set_instrument =  function (instrument_idx, track_idx, _)
        if self.is_not_active then return end
        -- save
        self.instrument_backup[self.instrument_idx] = self:state()
        -- switch
        self.instrument_idx = instrument_idx
        self.track_idx      = track_idx
        -- load
        local newState = self.instrument_backup[self.instrument_idx]
        if newState then self:load_state(newState) end
        -- refresh
        self:matrix_refresh()
    end
end
