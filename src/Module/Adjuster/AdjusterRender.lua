
--- ======================================================================================================
---
---                                                 [ Render Sub-Modul ]
---
--- will do the rendering of the matrix and all


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]

function Adjuster:__init_render()
    self:__create_matrix_listener()
end

function Adjuster:__activate_render()
    self:_refresh_matrix()
    self.pad:register_matrix_listener(self.__matrix_listener)
end

function Adjuster:__deactivate_render()
    self.pad:unregister_matrix_listener(self.__matrix_listener)
    self:_render_matrix()
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
            self:__update_selection(msg.x,msg.y)
            self:_update_bank_matrix_position(msg.x,msg.y)
            self:_render_matrix_position(msg.x, msg.y)
        else
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



-- todo maybe this shouldn't be called while activate and should be called by the different activate functions
-- todo maybe it is also a good idea to inline this function
function Adjuster:_refresh_matrix()
    self:_clear_pattern_matrix()
    self:_update_pattern_matrix()
    self:_clear_bank_matrix()
    self:_update_bank_matrix()
    self:_render_matrix()
end



--- ======================================================================================================
---
---                                                 [ subroutines ]

function Adjuster:_render_matrix()
    for x = 1, 8 do
        for y = 1, 4 do
            self:_render_matrix_position(x,y)
        end
    end
end

--- update pad by the given matrix
--
function Adjuster :_render_matrix_position(x,y)
    if(self.__pattern_matrix[x][y]) then
        self.pad:set_matrix(x,y,self.__pattern_matrix[x][y])
    else
        self.pad:set_matrix(x,y,AdjusterData.color.clear)
    end
    if(self.bank_matrix[x][y]) then
        self.pad:set_matrix(x, y, self.bank_matrix[x][y])
    end
end

