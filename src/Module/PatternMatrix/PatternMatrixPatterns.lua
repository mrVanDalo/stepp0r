function PatternMatrix:__init_patterns()
    self:__set_mix_rows()
end

function PatternMatrix:__activate_patterns()

end

function PatternMatrix:__deactivate_patterns()

end

function PatternMatrix:__set_mix_rows()
    self.pattern_mix_1 = self:__find_mix_row(PatternMatrixData.row.mix_1)
    self.pattern_mix_2 = self:__find_mix_row(PatternMatrixData.row.mix_2)
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

