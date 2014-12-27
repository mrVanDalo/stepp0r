require 'Layer/Util'

--- ======================================================================================================
---
---                                                 [ BooT ]

function Adjuster:_create_boot_callbacks()
    self:__create_matrix_listener()
    self:__create_select_pattern_listener()
end

function Adjuster:_activate()
    self:__activate_playback_position()
    -- selected pattern
    self.pattern_idx = renoise.song().selected_pattern_index
    add_notifier(renoise.song().selected_pattern_index_observable, self.__select_pattern_listener)
    -- bank matrix
    self:_clear_bank_matrix()
    self:_update_bank_matrix()
    -- main matrix
    self:_refresh_matrix()
    self.pad:register_matrix_listener(self.__matrix_listener)
end

--- tear down
--
function Adjuster:_deactivate()
    -- clear connected layers
    self:_matrix_clear()
    self:_clear_bank_matrix()
    self:_render_matrix()
    -- unregister notifiers/listeners
    self:__deactivate_playback_positioin()
    remove_notifier(renoise.song().selected_pattern_index_observable, self.__select_pattern_listener)
    self.pad:unregister_matrix_listener(self.__matrix_listener)
end



--- selected pattern has changed listener
function Adjuster:__create_select_pattern_listener()
    self.__select_pattern_listener = function (_)
        if self.is_not_active then return end
        self.pattern_idx = renoise.song().selected_pattern_index
        self:_refresh_matrix()
    end
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


