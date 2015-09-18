

--- ====================================================================================================
--- Pattern Mix Area
--
-- This is the area up there where the play loop is happening



function PatternMix:__init_area()
    -- todo : rename mix_area_1 mix_area_2
    self.pattern_mix_1              = nil
    self.pattern_mix_1_sequence_idx = nil
    self.pattern_mix_2              = nil
    self.pattern_mix_2_sequence_idx = nil
    --
    self.number_of_mix_patterns     = 2 -- value should be 1 or 2
    --
    self.mix_pattern_title          = "Stepp0r Mix"
    self.pattern_list_title         = "Patterns"
end
function PatternMix:__activate_area()
    self:__ensure_mix_patterns_exist()
    self:__set_mix_patterns()
end
function PatternMix:__deactivate_area()
    self:__remove_mix_patterns()
end

function PatternMix:set_number_of_mix_patterns(number)
    self.number_of_mix_patterns = number
end


--- find and save pattern-mix patterns (the ones with the strange label)
-- todo : rename
function PatternMix:__set_mix_patterns()
    local tupel = self:__find_mix_pattern(PatternMixData.row.mix_1)
    if tupel then
        self.pattern_mix_1              = tupel[2]
        self.pattern_mix_1_sequence_idx = tupel[1]
        --        print("found mix_1 sequence : ", self.pattern_mix_1_sequence_idx)
    else
        self.pattern_mix_1              = nil
        self.pattern_mix_1_sequence_idx = nil
        --        print("could not find mix_1 sequence")
    end
    local tupel_2 = self:__find_mix_pattern(PatternMixData.row.mix_2)
    if tupel_2 then
        self.pattern_mix_2              = tupel_2[2]
        self.pattern_mix_2_sequence_idx = tupel_2[1]
        --        print("found mix_2 sequence : ", self.pattern_mix_2_sequence_idx)
    else
        self.pattern_mix_2              = nil
        self.pattern_mix_2_sequence_idx = nil
        --        print("could not find mix_2 sequence")
    end
end
function PatternMix:__find_mix_pattern(key)
    for sequence_idx,pattern_idx in pairs(renoise.song().sequencer.pattern_sequence) do
        local pattern = renoise.song().patterns[pattern_idx]
        if pattern.name == key then
            return {sequence_idx, pattern}
        end
    end
    return nil
end

-- todo : make this more readable
function PatternMix:__ensure_mix_patterns_exist()
    self:__remove_mix_patterns()
    if self.number_of_mix_patterns == 2 then
        renoise.song().sequencer:insert_new_pattern_at(1)
        local idx_2 = renoise.song().sequencer:pattern(1)
        renoise.song().patterns[idx_2].name =  PatternMixData.row.mix_2
        renoise.song().sequencer:insert_new_pattern_at(1)
        local idx_1 = renoise.song().sequencer:pattern(1)
        renoise.song().patterns[idx_1].name =  PatternMixData.row.mix_1
        renoise.song().transport.loop_sequence_range = {1,2}
        renoise.song().sequencer:set_sequence_section_name(3, self.pattern_list_title)
        renoise.song().sequencer:set_sequence_is_start_of_section(3,true)
        renoise.song().transport.follow_player = true
    elseif self.number_of_mix_patterns == 1 then
        renoise.song().sequencer:insert_new_pattern_at(1)
        local idx_1 = renoise.song().sequencer:pattern(1)
        renoise.song().patterns[idx_1].name =  PatternMixData.row.mix_1
        renoise.song().transport.loop_sequence_range = {1,1}
        renoise.song().sequencer:set_sequence_section_name(2, self.pattern_list_title)
        renoise.song().sequencer:set_sequence_is_start_of_section(2,true)
        renoise.song().transport.follow_player = true
    end
    renoise.song().sequencer:set_sequence_section_name(1, self.mix_pattern_title)
    renoise.song().sequencer:set_sequence_is_start_of_section(1,true)
    renoise.song().selected_sequence_index = 1
end

function PatternMix:__remove_mix_patterns()
    self:__set_mix_patterns()
    if self.pattern_mix_2_sequence_idx then
        --        print("remove mix 2 ", self.pattern_mix_2_sequence_idx)
        renoise.song().sequencer:delete_sequence_at(self.pattern_mix_2_sequence_idx)
    end
    if self.pattern_mix_1_sequence_idx then
        --        print("remove mix 1 ", self.pattern_mix_1_sequence_idx)
        renoise.song().sequencer:delete_sequence_at(self.pattern_mix_1_sequence_idx)
    end
    renoise.song().sequencer:set_sequence_is_start_of_section(1,false)
    renoise.song().transport.loop_sequence_range = {0,0}
end
