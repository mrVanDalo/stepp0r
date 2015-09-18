class 'PatternMatrixObject'

function PatternMatrixObject:__init() end

function PatternMatrixObject:number_of_sequences()
    return table.count(renoise.song().sequencer.pattern_sequence)
end

function PatternMatrixObject:create_patterns_up_to_sequence_index(index)
    if index < 1 then return end
    local number_of_sequences = self:number_of_sequences()
    local to_create = index - number_of_sequences
    for counter = 1, to_create do
        renoise.song().sequencer:insert_new_pattern_at(number_of_sequences + counter)
    end
end


function PatternMatrixObject:alias_idx(pattern, track_idx)
    if pattern and track_idx and pattern.tracks[track_idx] and pattern.tracks[track_idx].is_alias then
        return pattern.tracks[track_idx].alias_pattern_index
    else
        return -1
    end
end
