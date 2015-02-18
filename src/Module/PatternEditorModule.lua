
--- ======================================================================================================
---
---                                                 [ Pattern Editor Module ]
---

--- A module to control Pattern Editor Modules

--- functions need to be implemented for children of this class
--- _render_matrix_position(x,y)

--- it delivers
--- self.__pattern_matrix



class "PatternEditorModule" (Module)

PatternEditorModuleData = {
    --- used in __pattern_matrix
    note = {
        on    = 1,
        off   = 120,
        empty = 121,
    },
}

function PatternEditorModule:__init(self)
    Module:__init(self)
    --
    self.__pattern_matrix = {} -- call _clear_pattern_matrix to use it
end


function PatternEditorModule:__render_matrix()
    for x = 1, 8 do
        for y = 1, 4 do
            self:__render_matrix_position(x,y)
        end
    end
end

function PatternEditorModule:__clear_pattern_matrix()
    self.__pattern_matrix = {}
    for x = 1, 8 do self.__pattern_matrix[x] = {} end
end

function PatternEditorModule:__update_pattern_matrix()
    local pattern_iter  = renoise.song().pattern_iterator
    for pos,line in pattern_iter:lines_in_pattern_track(self.pattern_idx, self.track_idx) do
        self:__update_pattern_matrix_position(pos,line)
    end
end
function PatternEditorModule:__update_pattern_matrix_position(pos,line)
    if table.is_empty(line.note_columns) then return end
    -- get note at position
    local note_column = line:note_column(self.track_column_idx)
    if (note_column.note_value == PatternEditorModuleData.note.empty) then return end
    -- calculate (x,y)
    local xy = self:line_to_point(pos.line)
    if not xy then return end
    local x = xy[1]
    local y = xy[2]
    if (y > 4 or y < 1) then return end
    -- update pattern matrix
    if (note_column.note_value == PatternEditorModuleData.note.off) then
        self.__pattern_matrix[x][y] = PatternEditorModuleData.note.off
    else
        self.__pattern_matrix[x][y] = PatternEditorModuleData.note.on
    end
end

