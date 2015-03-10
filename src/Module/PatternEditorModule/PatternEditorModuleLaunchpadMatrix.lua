function PatternEditorModule:__init_launchpad_matrix()
    self.__pattern_matrix          = {} -- call _clear_pattern_matrix to use it
    self.__pattern_matrix_inactive = {} -- call _clear_pattern_matrix to use it
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
    for x = 1, 8 do
        self.__pattern_matrix[x] = {
            PatternEditorModuleData.note.empty,
            PatternEditorModuleData.note.empty,
            PatternEditorModuleData.note.empty,
            PatternEditorModuleData.note.empty,
            PatternEditorModuleData.note.empty,
            PatternEditorModuleData.note.empty,
            PatternEditorModuleData.note.empty,
            PatternEditorModuleData.note.empty,
        }
        self.__pattern_matrix_inactive[x] = {
            PatternEditorModuleData.note.empty,
            PatternEditorModuleData.note.empty,
            PatternEditorModuleData.note.empty,
            PatternEditorModuleData.note.empty,
            PatternEditorModuleData.note.empty,
            PatternEditorModuleData.note.empty,
            PatternEditorModuleData.note.empty,
            PatternEditorModuleData.note.empty,
        }
    end
end

function PatternEditorModule:__update_pattern_matrix()
    local pattern_iter  = renoise.song().pattern_iterator
    for pos,line in pattern_iter:lines_in_pattern_track(self.pattern_idx, self.track_idx) do
        self:__update_pattern_matrix_position(pos,line)
    end
end
function PatternEditorModule:__update_pattern_matrix_position(pos,line)
    if table.is_empty(line.note_columns) then return end
    -- calculate (x,y)
    local xy = self:line_to_point(pos.line)
    if not xy then return end
    local x = xy[1]
    local y = xy[2]
    if (y > 4 or y < 1) then return end
    -- update pattern matrix
    for index = 1, 4 do
        if index == self.track_column_idx then
            -- update : patter_matrix
            local note_column = line:note_column(index)
            if (note_column.note_value == PatternEditorModuleData.note.empty)
            then
                self.__pattern_matrix[x][y] = PatternEditorModuleData.note.empty
            elseif (note_column.note_value == PatternEditorModuleData.note.off)
            then
                self.__pattern_matrix[x][y] = PatternEditorModuleData.note.off
            else
                self.__pattern_matrix[x][y] = PatternEditorModuleData.note.on
            end
        else
            -- update : patter_matrix_inactive
            local note_column = line:note_column(index)
            if (note_column.note_value == PatternEditorModuleData.note.empty)
            then
                if  self.__pattern_matrix_inactive[x][y] ~= PatternEditorModuleData.note.on
                        and self.__pattern_matrix_inactive[x][y] ~= PatternEditorModuleData.note.off
                then
                    self.__pattern_matrix_inactive[x][y] = PatternEditorModuleData.note.off
                end
                self.__pattern_matrix_inactive[x][y] = PatternEditorModuleData.note.empty
            elseif (note_column.note_value == PatternEditorModuleData.note.off)
            then
                if self.__pattern_matrix_inactive[x][y] ~= PatternEditorModuleData.note.on
                then
                    self.__pattern_matrix_inactive[x][y] = PatternEditorModuleData.note.off
                end
            else
                self.__pattern_matrix_inactive[x][y] = PatternEditorModuleData.note.on
            end
        end
    end
end

-- todo optimize me (together with __update_pattern_matrix_position
function PatternEditorModule:__set_pattern_matrix(x,y,value)
    if     value == PatternEditorModuleData.note.off then
        self.__pattern_matrix[x][y] = value
    elseif value == PatternEditorModuleData.note.empty then
        self.__pattern_matrix[x][y] = value
    else
        self.__pattern_matrix[x][y] = PatternEditorModuleData.note.on
    end
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

--- calculate point (for matrix) of line
--
-- nil for is not on the matrix
--
function PatternEditorModule:line_to_point(line)
    -- page
    local l = line - self.page_start
    if l < 1 then return end
    -- zoom
    local li = l
    if (self.zoom > 1) then
        if ((l - 1) % self.zoom) ~= 0 then return end
        li = ((l - 1) / self.zoom) + 1
    end
    -- transformation
    local x = ((li - 1) % 8) + 1
    local y = math.floor((li - 1) / 8) + 1
    return {x,y}
end

--- calculate the line a point given by the actual matrix configuration
--
-- point_to_line(line_to_point(l)) == l should allways be true ?
--
function PatternEditorModule:point_to_line(x,y)
    return ((x + (8 * (y - 1))) - 1) * self.zoom + 1 + self.page_start
end

--- calculates the position in track
--
-- the point should come from the launchpad.
-- the note_column that is selected will be taken in account
--
-- @return nil if nothing found
--
function PatternEditorModule:calculate_track_position(x,y)
    local line       = self:point_to_line(x,y)
    local pattern    = self:active_pattern()
    local found_line = pattern.tracks[self.track_idx].lines[line]
    if found_line then
        return found_line.note_columns[self.track_column_idx]
    else
        return nil
    end
end
