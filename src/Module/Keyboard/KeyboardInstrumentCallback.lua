

--- ======================================================================================================
---
---                                                 [ Keyboard Instrument Callback ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Keyboard:__init_keyboard_instrument_callback()
    self.instrument_idx    = 1
    self.track_idx         = 1
    self.velocity          = 127
    self.instrument_backup = {}
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
        -- save
        self.instrument_backup[self.instrument_idx] = self:state()
        -- switch
        self.instrument_idx = instrument_idx
        self.track_idx      = track_idx
        -- load
        local newState = self.instrument_backup[self.instrument_idx]
        if newState then self:load_state(newState) end
        if self.is_not_active then return end
        -- refresh
        self:matrix_refresh()
    end
end

--- save and load state
--
function Keyboard:state()
    return {
        note   = self.note,
        octave = self.octave,
    }
end
function Keyboard:load_state(state)
    self.note   = state.note
    self.octave = state.octave
end
