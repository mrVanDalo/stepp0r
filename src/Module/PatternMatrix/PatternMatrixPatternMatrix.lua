

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

function PatternMatrix:__get_sequencer_start()
    local y_start = self.__pattern_offset + 1
    for _,idx in pairs(self._sequence_idx_blacklist) do
        if idx <= y_start then
            y_start = y_start + 1
        end
    end
    return y_start
end

function PatternMatrix:__is_sequence_idx_blacklisted(idx)
    for _,blacklisted_idx in pairs(self._sequence_idx_blacklist) do
        if idx == blacklisted_idx then
            return true
        end
    end
    return false
end

function PatternMatrix:__get_sequence_interval_visible()
    local y_start = self:__get_sequencer_start()
    local y = 0
    local store = {}
    for y_raw = y_start, y_start + 9 + table.getn(self._sequence_idx_blacklist) do
        if not self:__is_sequence_idx_blacklisted(y_raw) then
            y = y + 1
            store[y] = y_raw
            if y > 7 then return store end
        end
    end
    return store
end

function PatternMatrix:__update_matrix_column(track_idx,x)
    for matrix_y, sequencer_idx in pairs(self:__get_sequence_interval_visible()) do
        local pattern_idx = renoise.song().sequencer.pattern_sequence[sequencer_idx]
        if pattern_idx then
            local pattern = renoise.song().patterns[pattern_idx]
            if pattern then
                local track = pattern.tracks[track_idx]
                if track then
                    if track.is_empty then
                        self.pattern_matrix[x][matrix_y] = { PatternMatrixData.matrix.state.empty , pattern_idx }
                    else
                        self.pattern_matrix[x][matrix_y] = { PatternMatrixData.matrix.state.full , pattern_idx }
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
function PatternMatrix:_get_pattern_idx(y)
    local sequence_idx = self:_get_sequence_for(y)
    self:_ensure_sequence_idx_exist(sequence_idx)
    return renoise.song().sequencer:pattern(sequence_idx)
end

function PatternMatrix:_get_sequence_for(x)
    return self:__get_sequence_interval_visible()[x]
end

