
--- ======================================================================================================
---
---                                                 [ Keyboard Launchpad Matrix ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Keyboard:__init_keyboard_matrix()
    self:__create_keyboard_listener()
end
function Keyboard:__activate_keyboard_matrix()
    self.pad:register_matrix_listener(self.keyboard_listener)
end
function Keyboard:__deactivate_keyboard_matrix()
    self.pad:register_matrix_listener(self.keyboard_listener)
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Keyboard:__create_keyboard_listener()
    self.keyboard_listener = function (_,msg)
        -- precondition
        if self.is_not_active        then return end
        if msg.y <= self.offset      then return  end
        if msg.y > (self.offset + 2) then return end
        -- scale to the keyboard
        local x = msg.x
        local y = msg.y - self.offset
        -- react on signal
        if (msg.vel == Velocity.release) then
            self:untrigger_note(x,y)
        elseif (y == 2) then
            -- second line notes only
            self:set_note(x, y)
            self:trigger_note(x,y)
        elseif (x == 1) then
            self:octave_down()
        elseif (x == 8) then
            self:octave_up()
        else
            self:set_note(x, y)
            self:trigger_note(x,y)
        end
        self:matrix_update_keys()
    end
end
