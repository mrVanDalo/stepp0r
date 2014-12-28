--- ======================================================================================================
---
---                                                 [ Rendering ]


--- update pad by the given matrix
--
function Editor:__render_matrix_position(x,y)
    if(self.matrix[x][y]) then
        self.pad:set_matrix(x,y,self.matrix[x][y])
    else
        self.pad:set_matrix(x,y,EditorData.color.clear)
    end
end

--- update memory-matrix by the current selected pattern
--
function Editor:__matrix_update()
    local pattern_iter  = renoise.song().pattern_iterator
    for pos,line in pattern_iter:lines_in_pattern_track(self.pattern_idx, self.track_idx) do
        if not table.is_empty(line.note_columns) then
            local note_column = line:note_column(self.track_column_idx)
            if(note_column.note_value ~= EditorData.note.empty) then
                local xy = self:line_to_point(pos.line)
                if xy then
                    local x = xy[1]
                    local y = xy[2]
                    if (y < 5 and y > 0) then
                        if (note_column.note_value == EditorData.note.off) then
                            self.matrix[x][y] = self.color.note.off
                        else
                            self.matrix[x][y] = self.color.note.on
                        end
                    end
                end
            end
        end
    end
end

function Editor:__matrix_clear()
    self.matrix = {}
    for x = 1, 8 do self.matrix[x] = {} end
end

function Editor:__render_matrix()
    for x = 1, 8 do
        for y = 1, 4 do
            self:__render_matrix_position(x,y)
        end
    end
end

