
function PatternMix:__init_current_and_next()
    self.active_mix_pattern         = nil   -- rename me to current_mix_pattern
    self.next_mix_pattern           = nil
end

function PatternMix:__activate_current_and_next()
    self:_set_active_and_next_patterns()
end

function PatternMix:__deactivate_current_and_next()
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
