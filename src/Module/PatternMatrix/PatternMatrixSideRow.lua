

function PatternMatrix:__init_side_row()
    self:__create_side_listener()
end

function PatternMatrix:__activate_side_row()
    self:_render_row()
    self.pad:register_side_listener(self.__side_listener)
end

function PatternMatrix:__deactivate_side_row()
    self:__clear_row()
    self.pad:unregister_side_listener(self.__side_listener)
end

function PatternMatrix:_render_row()
    local color = self.mode_color.mix
    if self.mode == PatternMatrixData.mode.clear then
        color = self.mode_color.clear
    elseif self.mode == PatternMatrixData.mode.copy then
        color = self.mode_color.copy
    end
    for x = 1,8 do
        self.pad:set_side(x, color)
    end
end

function PatternMatrix:__clear_row()
    for x = 1,8 do
        self.pad:set_side(x, Color.off)
    end
end

function PatternMatrix:__create_side_listener()
    self.__side_listener = function (_, msg)
        if self.is_not_active then return end
        if msg.vel ~= Velocity.release then return end
        if self.mode == PatternMatrixData.mode.mix then
            self:__set_row_to_next_pattern(msg.x)
        elseif self.mode == PatternMatrixData.mode.copy then
            self:__copy_pattern_row(msg.x)
        else
            self:__clear_pattern_row(msg.x)
        end
    end
end

-- @return all track indecies (which should be rendered)
function PatternMatrix:__all_tracks()
    local result = {}
    for track_idx = 1, table.getn(renoise.song().tracks) do
        result[track_idx] = track_idx
    end
    return result
end

function PatternMatrix:__set_row_to_next_pattern(x)
    local sequence_idx = self:_get_sequence_for(x)
    self:_ensure_sequence_idx_exist(sequence_idx)
    local pattern_idx  = renoise.song().sequencer.pattern_sequence[sequence_idx]
    for _,track_idx in pairs(self:__all_tracks()) do
        self:_set_mix_to_pattern(track_idx, pattern_idx)
    end
    self:_refresh_matrix()
end
function PatternMatrix:__copy_pattern_row(x)
    local sequence_idx = self:_get_sequence_for(x)
    self:_ensure_sequence_idx_exist(sequence_idx)
    local pattern_idx  = renoise.song().sequencer.pattern_sequence[sequence_idx]
    for _,track_idx in pairs(self:__all_tracks()) do
        local alias_idx   = self:_get_pattern_alias_idx(self.active_mix_pattern, track_idx)
        if alias_idx ~= -1 then
            local source_pattern_track = renoise.song().patterns[alias_idx].tracks[track_idx]
            renoise.song().patterns[pattern_idx].tracks[track_idx]:copy_from(source_pattern_track)
            self:_set_mix_to_pattern(track_idx, pattern_idx)
        end
    end
    self:_refresh_matrix()
end
function PatternMatrix:__clear_pattern_row(x)
    local sequence_idx = self:_get_sequence_for(x)
    self:_ensure_sequence_idx_exist(sequence_idx)
    local pattern_idx  = renoise.song().sequencer.pattern_sequence[sequence_idx]
    for _,track_idx in pairs(self:__all_tracks()) do
        renoise.song().patterns[pattern_idx].tracks[track_idx]:clear()
    end
    self:_refresh_matrix()
end
