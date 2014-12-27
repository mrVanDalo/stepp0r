
--- ======================================================================================================
---
---                                                 [ Pattern Matrix Sub-Module]

--- selection on the pattern matrix space to select the knobs to copy (and where to paste them)

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]

function Adjuster:__init_pattern()
    self.__pattern_matrix = {}
end

function Adjuster:__activate_pattern()
    -- done by  __activate_render
end

function Adjuster:__deactivate_pattern()
    self:_clear_pattern_matrix()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Adjuster:_update_pattern_matrix()
    local pattern_iter  = renoise.song().pattern_iterator
    for pos,line in pattern_iter:lines_in_pattern_track(self.pattern_idx, self.track_idx) do
        self:__update_pattern_matrix_position(pos,line)
    end
end
function Adjuster:__update_pattern_matrix_position(pos,line)
    if table.is_empty(line.note_columns) then return end
    -- get note at position
    local note_column = line:note_column(self.track_column_idx)
    if (note_column.note_value == AdjusterData.note.empty) then return end
    -- calculate (x,y)
    local xy = self:line_to_point(pos.line)
    if not xy then return end
    local x = xy[1]
    local y = xy[2]
    if (y > 4 or y < 1) then return end
    -- update pattern matrix
    if (note_column.note_value == AdjusterData.note.off) then
        self.__pattern_matrix[x][y] = self.color.note.off
    else
        self.__pattern_matrix[x][y] = self.color.note.on
    end
end

function Adjuster:_clear_pattern_matrix()
    self.__pattern_matrix = {}
    for x = 1, 8 do self.__pattern_matrix[x] = {} end
end
