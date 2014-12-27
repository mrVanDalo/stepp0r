
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




function Adjuster:_refresh_matrix()
    self:_matrix_clear()
    self:_matrix_update()
    self:_clear_bank_matrix()
    self:_update_bank_matrix()
    self:_render_matrix()
end

--- update memory-matrix by the current selected pattern
--
function Adjuster:_matrix_update()
    local pattern_iter  = renoise.song().pattern_iterator
    for pos,line in pattern_iter:lines_in_pattern_track(self.pattern_idx, self.track_idx) do
        self:__update_matrix_position(pos,line)
    end
end

function Adjuster:__update_matrix_position(pos,line)
    if table.is_empty(line.note_columns) then return end

    local note_column = line:note_column(self.track_column_idx)
    if (note_column.note_value == AdjusterData.note.empty) then return end

    local xy = self:line_to_point(pos.line)
    if not xy then return end

    local x = xy[1]
    local y = xy[2]
    if (y > 4 or y < 1) then return end

    if (note_column.note_value == AdjusterData.note.off) then
        self.__pattern_matrix[x][y] = self.color.note.off
    else
        self.__pattern_matrix[x][y] = self.color.note.on
    end
end


function Adjuster:_matrix_clear()
    self.__pattern_matrix = {}
    for x = 1, 8 do self.__pattern_matrix[x] = {} end
end

function Adjuster:_render_matrix()
    for x = 1, 8 do
        for y = 1, 4 do
            self:_render_matrix_position(x,y)
        end
    end
end

--- ======================================================================================================
---
---                                                 [ subroutines ]

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

