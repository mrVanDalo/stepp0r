function PatternMatrix:__init_pattern_mix()
    self._sequence_idx_blacklist    = {}
    self.current_mix_pattern         = nil
    self.next_mix_pattern           = nil
    --
    self:__create_pattern_mix_update_callback()
end

function PatternMatrix:__activate_pattern_mix()
end

function PatternMatrix:__deactivate_pattern_mix()
end

function PatternMatrix:wire_pattern_mix(pattern_mix)
    self.pattern_mix = pattern_mix
end

function PatternMatrix:_set_next(track_idx, pattern_idx)
    self.pattern_mix:set_next(track_idx, pattern_idx)
end

function PatternMatrix:__create_pattern_mix_update_callback()
    self.pattern_mix_update_callback = function (update)
        self.current_mix_pattern        = update.current
        self.next_mix_pattern           = update.next
        self._sequence_idx_blacklist    = update.sequence_idx_blacklist
        self.pattern_mix_2_sequence_idx = update.mix_2_idx
        if self.is_not_active then return end
        self:_refresh_matrix()
    end
end
