
--- ======================================================================================================
---
---                                                 [ Keyboard Set Note Callback ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Keyboard:__init_keyboard_set_note()
    self.callback_set_note = {}
end
function Keyboard:__activate_keyboard_set_note()
end
function Keyboard:__deactivate_keyboard_set_note()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

--- note arithmetics
-- x and y are relative to the keyboard, not on the matrix!
function Keyboard:set_note(x,y)
    self.note = KeyboardData.reverse_mapping[y][x]
    -- fullfill callbacks
    for _, callback in ipairs(self.callback_set_note) do
        callback(self.note, self.octave)
    end
end
