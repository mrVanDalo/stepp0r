

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
    local color = PatternMatrix.color.SELECT
    if self.mode:is_clear() then
        color = PatternMatrix.color.CLEAR
    elseif self.mode:is_copy() then
        color = PatternMatrix.color.COPY
    elseif self.mode:is_insert_scene() then
        color = PatternMatrix.color.INSERT
    elseif self.mode:is_remove_scene() then
        color = PatternMatrix.color.REMOVE
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
        --
        if self.mode:is_select()    then self:__select_pattern_row(msg.x)
        elseif self.mode:is_copy()  then self:__copy_pattern_row(msg.x)
        elseif self.mode:is_clear() then self:__clear_pattern_row(msg.x)
        elseif self.mode:is_remove_scene() then self:__remove_row(msg.x)
        elseif self.mode:is_insert_scene() then self:__insert_row(msg.x)
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

function PatternMatrix:__select_pattern_row(x)
    local sequence_idx = self:_get_sequence_for(x)
    self:_ensure_sequence_idx_exist(sequence_idx)
    local pattern_idx  = renoise.song().sequencer.pattern_sequence[sequence_idx]
    for _,track_idx in pairs(self:__all_tracks()) do
        self:_set_next(track_idx, pattern_idx)
    end
    self:_refresh_matrix()
end
function PatternMatrix:__copy_pattern_row(x)
    local sequence_idx = self:_get_sequence_for(x)
    self:_ensure_sequence_idx_exist(sequence_idx)
    local pattern_idx  = renoise.song().sequencer.pattern_sequence[sequence_idx]
    for _,track_idx in pairs(self:__all_tracks()) do
        local alias_idx = Renoise.pattern_matrix:alias_idx(self.current_mix_pattern, track_idx)
        if alias_idx then
            local source_pattern_track = renoise.song().patterns[alias_idx].tracks[track_idx]
            renoise.song().patterns[pattern_idx].tracks[track_idx]:copy_from(source_pattern_track)
            self:_set_next(track_idx, pattern_idx)
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
function PatternMatrix:__remove_row(x)
    local sequence_idx = self:_get_sequence_for(x)
    Renoise.pattern_matrix:remove_sequence_index(sequence_idx)
    self:_refresh_matrix()
end
function PatternMatrix:__insert_row(x)
    local sequence_idx = self:_get_sequence_for(x)
    Renoise.pattern_matrix:insert_sequence_at_index(sequence_idx)
    self:_refresh_matrix()
end
