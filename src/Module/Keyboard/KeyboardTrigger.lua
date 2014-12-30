--- ======================================================================================================
---
---                                                 [ Keyboard Trigger ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Keyboard:__init_keyboard_trigger()
    self.triggered_notes = {
        {nil,nil, nil, nil, nil, nil, nil, nil },
        {nil,nil, nil, nil, nil, nil, nil, nil }
    }
end
function Keyboard:__activate_keyboard_trigger()
end
function Keyboard:__deactivate_keyboard_trigger()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Keyboard:trigger_note(x,y)
    if is_not_off(self.note) then
        local note = pitch(self.note,self.octave)
        self.triggered_notes[y][x] = note
        self.osc_client:trigger_note(self.instrument_idx, self.track_idx, note, self.velocity)
    end
end

function Keyboard:untrigger_note(x,y)
    local note = self.triggered_notes[y][x]
    if not note then return end
    self.osc_client:untrigger_note(self.instrument_idx, self.track_idx, note)
end


