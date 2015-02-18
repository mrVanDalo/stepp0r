
--- ======================================================================================================
---
---                                                 [ Launchpad Matrix Sub-Modul ]
---
--- will do the rendering of the matrix and all


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]

function Adjuster:__init_launchpad_matrix()
    self:__create_matrix_listener()
end

function Adjuster:__activate_launchpad_matrix()
    self:_refresh_matrix()
    self.pad:register_matrix_listener(self.__matrix_listener)
end

function Adjuster:__deactivate_launchpad_matrix()
    self.pad:unregister_matrix_listener(self.__matrix_listener)
    self:__render_matrix()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

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
            self:__copy_selection(msg.x,msg.y)
            self:_update_bank_matrix_position(msg.x,msg.y)
            self:__render_matrix_position(msg.x, msg.y)
        else
            self:__paste_selection(msg.x,msg.y)
            self:_refresh_matrix()
        end
    end
end

function Adjuster:__paste_selection(x,y)
    local line = self:point_to_line(x,y)
    self:_insert_bank_at_line(line)
end

function Adjuster:__copy_selection(x,y)
    local line = self:point_to_line(x,y)
    if self.bank.bank[line] then
        self:_clear_bank_interval(line, (line + self.zoom - 1))
    else
        self:_update_bank_interval(line, (line + self.zoom - 1))
    end
end

function Adjuster:_refresh_matrix()
    self:__clear_pattern_matrix()
    self:__update_pattern_matrix()
    self:_clear_bank_matrix()
    self:_update_bank_matrix()
    self:__render_matrix()
end


--- update pad by the given matrix
--
function Adjuster:__render_matrix_position(x,y)
    if     (self.__pattern_matrix[x][y] == PatternEditorModuleData.note.on) then
        self.pad:set_matrix(x,y,self.color.note.on)
    elseif (self.__pattern_matrix[x][y] == PatternEditorModuleData.note.off) then
        self.pad:set_matrix(x,y,self.color.note.off)
    else
        self.pad:set_matrix(x,y,self.color.note.empty)
    end
    -- bank_matrix has color already in it
    if(self.bank_matrix[x][y]) then
        self.pad:set_matrix(x, y, self.bank_matrix[x][y])
    end
end

