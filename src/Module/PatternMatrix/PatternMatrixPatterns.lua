function PatternMatrix:__init_patterns()
--    self.pattern_mix_1              = nil
    self.pattern_mix_1_sequence_idx = nil
--    self.pattern_mix_2              = nil
    self.pattern_mix_2_sequence_idx = nil
    self.active_mix_pattern         = nil
    self.next_mix_pattern           = nil
    --
    self:__create_pattern_mix_update_callback()
end

function PatternMatrix:__activate_patterns()
end

function PatternMatrix:__deactivate_patterns()
end

function PatternMatrix:__create_selected_pattern_idx_listener()
end


function PatternMatrix:_get_pattern_alias_idx(pattern, track_idx)
end

function PatternMatrix:__set_mix_patterns()
end

function PatternMatrix:__set_active_and_next_patterns()
end

-- @returns the mix pattern which should be used to alias the next pattern in.
function PatternMatrix:_next_mix_pattern()
end

function PatternMatrix:_active_mix_pattern()
end

function PatternMatrix:__find_mix_pattern(key)
end

function PatternMatrix:__adjuster_next_patterns()
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
        print("update pattern mix")
        self.active_mix_pattern         = update.active
        self.next_mix_pattern           = update.next
        self.pattern_mix_1_sequence_idx = update.mix_1_idx
        self.pattern_mix_2_sequence_idx = update.mix_2_idx
    end
end
