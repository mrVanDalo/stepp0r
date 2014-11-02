
--- ======================================================================================================
---
---                                                 [ Rendering ]




function Adjuster:_refresh_matrix()
    self:_matrix_clear()
    self:_matrix_update()
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
            self:__render_matrix_position(x,y)
        end
    end
end

--- ======================================================================================================
---
---                                                 [ subroutines ]

--- update pad by the given matrix
--
function Adjuster:__render_matrix_position(x,y)
    if(self.__pattern_matrix[x][y]) then
        self.pad:set_matrix(x,y,self.__pattern_matrix[x][y])
    else
        self.pad:set_matrix(x,y,AdjusterData.color.clear)
    end
    if(self.bank_matrix[x][y]) then
        self.pad:set_matrix(x, y, self.bank_matrix[x][y])
    end
end

