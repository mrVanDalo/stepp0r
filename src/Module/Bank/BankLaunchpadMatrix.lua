
--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]

function Bank:__init_matrix()
    self:__create_matrix_listener()
    for x = 1, 8 do self.banks[x] = create_bank() end
end
function Bank:__activate_matrix()
    self.pad:register_matrix_listener(self.__matrix_listener)
end
function Bank:__deactivate_matrix()
    self.pad:unregister_matrix_listener(self.__matrix_listener)
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Bank:__create_matrix_listener()
    self.__matrix_listener = function (_,msg)
        if self.is_not_active        then return end
        if Velocity.press == msg.vel then return end
        local y = msg.y - self.offset
        if y == 1 then
            self:__toggle_mode(msg.x)
        elseif y == 2 then
            self:_clear_bank(msg.x)
        end
    end
end

function Bank:__toggle_mode(bank_idx)
    if self.bank_idx ~= bank_idx then
        self.bank_idx = bank_idx
        self.mode = BankData.mode.copy
    else
        if self.mode == BankData.mode.copy then
            self.mode = BankData.mode.paste
        else
            self.mode = BankData.mode.copy
        end
    end
    self:_update_bank_listeners()
    self:_render_matrix()
end

function Bank:_clear_bank(bank_idx)
    self.bank_idx = bank_idx
    self.mode = BankData.mode.copy
    self.banks[self.bank_idx] = create_bank()
    self:_update_bank_listeners()
    self:_render_matrix()
end

function Bank:_render_matrix()
    local y1 = 1 + self.offset
    local y2 = 2 + self.offset
    for x = 1, 8 do
        if x == self.bank_idx then
            if self.mode == BankData.mode.copy then
                self.pad:set_matrix(x, y1, self.color.toggle.selected.copy)
            else
                self.pad:set_matrix(x, y1, self.color.toggle.selected.paste)
            end
        else
            self.pad:set_matrix(x, y1, self.color.toggle.unselected)
        end
        self.pad:set_matrix(x, y2, self.color.clear)
    end
end

function Bank:_clear_matrix()
    local y1 = 1 + self.offset
    local y2 = 2 + self.offset
    for x = 1, 8 do
        self.pad:set_matrix(x,y1, Color.off)
        self.pad:set_matrix(x,y2, Color.off)
    end
end