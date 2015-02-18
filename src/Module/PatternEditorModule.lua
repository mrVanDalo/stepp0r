
--- ======================================================================================================
---
---                                                 [ Pattern Editor Module ]
---

--- A module to control Pattern Editor Modules

--- functions need to be implemented for children of this class
--- _render_matrix_position(x,y)

--- it delivers
--- self.__pattern_matrix (+ functions)
--- self.callback_set_pattern
--- self.callback_set_instrument


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
    --
    self.pattern_idx      = 1 -- actual pattern
    self:__create_callback_set_pattern()
    --
    self.track_idx        = 1
    self.instrument_idx   = 1
    self.track_column_idx = 1 -- the column in the track
    self:__create_callback_set_instrument()
end

----- instrument / track


function PatternEditorModule:__create_callback_set_instrument()
    self.callback_set_instrument =  function (instrument_idx, track_idx, column_idx)
        self.track_idx        = track_idx
        self.track_column_idx = column_idx
        self.instrument_idx   = instrument_idx
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end



----- pattern


function PatternEditorModule:__create_callback_set_pattern()
    self.callback_set_pattern = function (index)
        self.pattern_idx = index
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end

function PatternEditorModule:active_pattern()
    return renoise.song().patterns[self.pattern_idx]
end


------ matrix

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
    local xy = self:line_to_point(pos.line) -- todo missing
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

