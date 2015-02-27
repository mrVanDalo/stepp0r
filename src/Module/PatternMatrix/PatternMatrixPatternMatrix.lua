

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
        self:__update_matrix_column(x)
    end
end

function PatternMatrix:__update_matrix_column(x)
    local y_start = (self.__pattern_page - 1) * 8 + 1
    if self.pattern_mix_1_sequence_idx <= y_start then
        y_start = y_start + 1
    end
    if self.pattern_mix_2_sequence_idx <= y_start then
        y_start = y_start + 1
    end
    for y = y_start, y_start + 8 do
        if self.pattern_mix_1_sequence_idx ~= y and
                self.pattern_mix_2_sequence_idx ~= y
        then
            local pattern_idx = renoise.song().sequencer.pattern_sequence[y]
            if pattern_idx then
                local pattern = renoise.song().patterns[pattern_idx]
                if pattern then
                    local matrix_type = PatternMatrixData.matrix.state.full
                    if pattern.is_empty then
                        matrix_type = PatternMatrixData.matrix.state.empty
                    end
                    self.pattern_matrix[x][y] = {matrix_type, pattern_idx}
                end
            end
        end
    end
end


