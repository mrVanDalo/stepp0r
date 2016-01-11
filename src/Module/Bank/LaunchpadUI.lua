
--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]

function Bank:__init_matrix()
    self:__create_matrix_listener()
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
            self:pressed_select(msg.x)
        elseif y == 2 then
            self:pressed_clear(msg.x)
        end
    end
end

function Bank:pressed_select(bank_idx)
    if self.bank_idx == bank_idx then
        self.store:toggle_mode()
    else
        self.bank_idx = bank_idx
        self.store:select(self.bank_idx)
    end
    self.mode = self.store.mode
    self:_render_matrix()
end

function Bank:pressed_clear(bank_idx)
    self.mode = CopyPasteStore.COPY_MODE
    self.bank_idx = bank_idx
    self.store:select(bank_idx)
    self.store:reset()
    self:_render_matrix()
end


function Bank:_render_matrix()

    local y1 = 1 + self.offset
    local y2 = 2 + self.offset

    local render_part = function(x, copy_color, paste_color, clear_color, unselected_color)
        if x == self.bank_idx then
            if self.mode == CopyPasteStore.COPY_MODE then
                self.pad:set_matrix(x, y1, copy_color)
            else
                self.pad:set_matrix(x, y1, paste_color)
            end
        else
            self.pad:set_matrix(x, y1, unselected_color)
        end
        self.pad:set_matrix(x, y2, clear_color)
    end

    for x = 1, 4 do
        render_part(x,
            Bank.color.single.copy,
            Bank.color.single.paste,
            Bank.color.single.clear,
            Bank.color.single.unselected
        )
    end
    for x = 5, 8 do
        render_part(x,
            Bank.color.multi.copy,
            Bank.color.multi.paste,
            Bank.color.multi.clear,
            Bank.color.multi.unselected
        )
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