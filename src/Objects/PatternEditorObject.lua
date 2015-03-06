

class 'PatternEditorObject'

function PatternEditorObject:__init() end

-- maybe this should be moved to an object called pattern
function PatternEditorObject:is_selected_pattern_played()
    local pos = renoise.song().transport.playback_pos
    local playback_pattern_idx = renoise.song().sequencer:pattern(pos.sequence)
    local selected_pattern = renoise.song().selected_pattern_index
    return playback_pattern_idx == selected_pattern
end

-- maybe this should be moved to an object called sequence
function PatternEditorObject:is_selected_sequence_played()
    local pos = renoise.song().transport.playback_pos
    local playback_sequence_idx = pos.sequence
    local selected_sequence_idx = renoise.song().selected_sequence_index
    return playback_sequence_idx == selected_sequence_idx
end
