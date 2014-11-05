
function Bank:_first_run()
    self:__create_matrix_listener()
    for x = 1, 8 do self.banks[x] = self:_create_bank() end
end

function Bank:_activate()
    self.pad:register_matrix_listener(self.__matrix_listener)
    self:_render_matrix()
end

function Bank:_deactivate()
    self.pad:unregister_matrix_listener(self.__matrix_listener)
    self:_clear_matrix()
end


function Bank:__create_matrix_listener()
    self.__matrix_listener = function (_,msg)
        if self.is_not_active then return end
        if Velocity.press == msg.vel then return end
        local y = msg.y - self.offset
        if y == 1 then
            self:_toggle_mode(msg.x)
        elseif y == 2 then
            self:_clear_bank(msg.x)
        end
    end
end