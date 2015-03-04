function PatternMatrix:__init_patterns()
    self._sequence_idx_blacklist    = {}
    self.active_mix_pattern         = nil
    self.next_mix_pattern           = nil
    --
    self:__create_pattern_mix_update_callback()
end

function PatternMatrix:__activate_patterns()
end

function PatternMatrix:__deactivate_patterns()
end

function PatternMatrix:_get_pattern_alias_idx(pattern, track_idx)
    if pattern and pattern.tracks[track_idx] and pattern.tracks[track_idx].is_alias then
        return pattern.tracks[track_idx].alias_pattern_index
    else
        return -1
    end
end

function PatternMatrix:_set_mix_to_pattern(track_idx, pattern_idx)
    -- get pattern
    local mix_pattern = self.next_mix_pattern
    if not mix_pattern then return end
    -- get track
    local track = mix_pattern.tracks[track_idx]
    if not track then return end
    --
    if pattern_idx ~= -1 then
        track.alias_pattern_index = pattern_idx
    end
end

function PatternMatrix:__create_pattern_mix_update_callback()
    self.pattern_mix_update_callback = function (update)
        self.active_mix_pattern         = update.active
        self.next_mix_pattern           = update.next
        -- todo remove this and replace by table of black-listed sequencer_idx
        self._sequence_idx_blacklist    = update.sequence_idx_blacklist
        self.pattern_mix_2_sequence_idx = update.mix_2_idx
        if self.is_not_active then return end
        self:_refresh_matrix()
    end
end
