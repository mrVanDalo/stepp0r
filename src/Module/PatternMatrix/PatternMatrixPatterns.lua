
function PatternMatrix:find_mix_row()
    local pattern_size = table.getn(renoise.song().patterns)
    for pattern_idx = 1, pattern_size do
        local pattern = renoise.song().patterns[pattern_idx]
        if pattern.name == PatternMatrixData.row.mix_1 then
            return pattern
        end
    end
    return nil
end

function PatternMatrix:set_mix_to_pattern(track_idx, pattern_idx)
    -- get pattern
    local mix_pattern = self:find_mix_row()
    if not mix_pattern then return end
    -- get track
    local track = mix_pattern.tracks[track_idx]
    if not track then return end
    --
    track.alias_pattern_index = pattern_idx
end

