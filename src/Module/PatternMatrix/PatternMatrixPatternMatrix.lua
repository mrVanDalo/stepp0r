

function PatternMatrix:__init_pattern_matrix()
    self.pattern_matrix = {}
end

function PatternMatrix:__activate_pattern_matrix()
end

function PatternMatrix:__deactivate_pattern_matrix()
end

function PatternMatrix:_clear_matrix()
    for x = 1, 8 do
        self.pattern_matrix[x] = {}
    end
end

function PatternMatrix:_update_matrix()
    for x = 1, 8 do
        self:__update_matrix_column(self:_get_track_idx(x), x)
    end
end

function PatternMatrix:__update_matrix_column(track_idx,x)
    local y_start = (self.__pattern_page - 1) * 8 + 1
    if self.pattern_mix_1_sequence_idx <= y_start then
        y_start = y_start + 1
    end
    if self.pattern_mix_2_sequence_idx <= y_start then
        y_start = y_start + 1
    end
    local y = 0
    for y_raw = y_start, y_start + 10 do
        if self.pattern_mix_1_sequence_idx ~= y_raw and
           self.pattern_mix_2_sequence_idx ~= y_raw
        then
            y = y + 1
            if y > 8 then return end
            local pattern_idx = renoise.song().sequencer.pattern_sequence[y_raw]
            if pattern_idx then
                local pattern = renoise.song().patterns[pattern_idx]
                if pattern then
                    local track = pattern.tracks[track_idx]
                    if track then
                        local matrix_type = PatternMatrixData.matrix.state.full
                        if track.is_empty then
                            matrix_type = PatternMatrixData.matrix.state.empty
                        end
                        self.pattern_matrix[x][y] = {matrix_type, pattern_idx }
                    end
                end
            end
        end
    end
end

function PatternMatrix:__set_empty_to_matrix(x,y)
    self.pattern_matrix[x][y] = {PatternMatrixData.matrix.state.empty, -1}
end

-- @param x on the pattern_matrix
-- @param y on the pattern_matrix
function PatternMatrix:_get_pattern_idx(x,y)
    return self.pattern_matrix[x][y][PatternMatrixData.matrix.access.pattern_idx]
end


