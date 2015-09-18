
function PatternMix:__init_current_and_next()
    self.pattern_mix_1              = nil
    self.pattern_mix_1_sequence_idx = nil
    self.pattern_mix_2              = nil
    self.pattern_mix_2_sequence_idx = nil
    --
    self.active_mix_pattern         = nil   -- rename me to current_mix_pattern
    self.next_mix_pattern           = nil
    --
    self.number_of_mix_patterns     = 2 -- value should be 1 or 2
end

function PatternMix:__activate_current_and_next()
    self:_set_mix_patterns()
    self:_set_active_and_next_patterns()
end

function PatternMix:__deactivate_current_and_next()
end

--- ============================================================
--- pattern mix row (the one on top)
--- todo : move this to its own package and rename it to something better than pattern mix

--- find and save pattern-mix patterns (the ones with the strange label)
function PatternMix:_set_mix_patterns()
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




--- next and current

function PatternMix:_set_active_and_next_patterns()
    self.active_mix_pattern = self:_active_mix_pattern()
    print("found active_mix_pattern at : ", self.active_mix_pattern.name)
    self.next_mix_pattern   = self:_next_mix_pattern()
    print("found next_mix_pattern at : ", self.next_mix_pattern.name)
end

-- @returns the mix pattern which should be used to alias the next pattern in.
function PatternMix:_next_mix_pattern()
    if (self.pattern_mix_1 and self.pattern_mix_2) then
        if self.active_mix_pattern == self.pattern_mix_2 then
            return self.pattern_mix_1
        else
            return self.pattern_mix_2
        end
    end
    -- there is only one pattern mix available
    if self.pattern_mix_1 then
        return self.pattern_mix_1
    end
    if self.pattern_mix_2 then
        return self.pattern_mix_2
    end
end

function PatternMix:_active_mix_pattern()
    if (self.pattern_mix_1 and self.pattern_mix_2) then
        if renoise.song().selected_pattern == self.pattern_mix_2 then
            return self.pattern_mix_2
        else
            return self.pattern_mix_1
        end
    end
    -- there is only one pattern mix available
    if self.pattern_mix_1 then
        return self.pattern_mix_1
    end
    if self.pattern_mix_2 then
        return self.pattern_mix_2
    end
    return nil
end
