function PatternMatrix:__init_patterns()
    self.pattern_mix_1 = nil
    self.pattern_mix_2 = nil
    self.active_mix_row = nil
end

function PatternMatrix:__activate_patterns()
    self:__set_mix_rows()
end

function PatternMatrix:__deactivate_patterns()

end

function PatternMatrix:__set_mix_rows()
    self.pattern_mix_1 = self:__find_mix_row(PatternMatrixData.row.mix_1)
    self.pattern_mix_2 = self:__find_mix_row(PatternMatrixData.row.mix_2)
end

-- @returns the mix row which should be used to alias the next pattern in.
function PatternMatrix:_next_mix_row()
end

function PatternMatrix:_active_mix_row()
    if (self.pattern_mix_1 and self.pattern_mix_2) then
        if self.active_mix_row == self.pattern_mix_2 then
            return self.pattern_mix_2
        else
            return self.pattern_mix_1
        end
    end
    if self.pattern_mix_1 then
        return self.pattern_mix_1
    end
    if self.pattern_mix_2 then
        return self.pattern_mix_2
    end
    return nil
end

function PatternMatrix:__find_mix_row()
    for _,pattern_idx in pairs(renoise.song().sequencer.pattern_sequence) do
        local pattern = renoise.song().patterns[pattern_idx]
        if pattern.name == PatternMatrixData.row.mix_1 then
            return pattern
        end
    end
    return nil
end

function PatternMatrix:set_mix_to_pattern(track_idx, pattern_idx)
    -- get pattern
    local mix_pattern = self:__find_mix_row()
    if not mix_pattern then return end
    -- get track
    local track = mix_pattern.tracks[track_idx]
    if not track then return end
    --
    track.alias_pattern_index = pattern_idx
end

