require 'Layer/Util'

--- ======================================================================================================
---
---                                                 [ BooT ]

function Adjuster:_create_boot_callbacks()
    self:__create_matrix_listener()
end

function Adjuster:_activate()
    self:__activate_playback_position()
    self:__activate_bank()
    self:__activate_selected_pattern()
    self:__activate_pagination()

    -- main matrix
    self:_refresh_matrix()
    self.pad:register_matrix_listener(self.__matrix_listener)
end

--- tear down
--
function Adjuster:_deactivate()
    self:__deactivate_bank()
    self:__deactivate_playback_positioin()
    self:__deactivate_selected_pattern()
    self:__deactivate_pagination()

    self.pad:unregister_matrix_listener(self.__matrix_listener)
end




--- pad matrix listener
--
-- listens on click events on the launchpad matrix
function Adjuster:__create_matrix_listener()
    self.__matrix_listener = function (_,msg)
        if self.is_not_active          then return end
        if msg.vel ~= Velocity.release then return end
        if msg.y > 4                   then return end
        local column = self:calculate_track_position(msg.x,msg.y)
        if not column then return end
        if (self.mode == BankData.mode.copy) then
--            print("copy mode")
            self:__update_selection(msg.x,msg.y)
            self:_update_bank_matrix_at_point(msg.x,msg.y)
            self:_render_matrix_position(msg.x, msg.y)
        else
--            print("paste mode")
            self:__insert_selection(msg.x,msg.y)
            self:_refresh_matrix()
        end
        self:_log_bank()
    end
end

-- todo optimize me
function Adjuster:__update_selection(x,y)
    local line = self:point_to_line(x,y)
    if self.bank.bank[line] then
--        print('clear bank : ' .. line .. ',' .. (line + self.zoom - 1))
        self:_clear_bank_interval(line, (line + self.zoom - 1))
    else
--        print('set bank : ' .. line .. ',' .. (line + self.zoom - 1))
        self:_set_bank_interval(line, (line + self.zoom - 1))
    end
end


function Adjuster:__insert_selection(x,y)
    local line = self:point_to_line(x,y)
    self:_insert_bank_at(line)
end


