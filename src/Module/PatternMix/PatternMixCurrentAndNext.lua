
function PatternMix:__init_current_and_next()
    self.current_mix_pattern        = nil
    self.next_mix_pattern           = nil
end

function PatternMix:__activate_current_and_next()
    self:_update_current_and_next()
end

function PatternMix:__deactivate_current_and_next()
end

function PatternMix:__adjuster_next_pattern()
    print("adjust next pattern")
    for _,track_idx in pairs(Renoise.track:list_idx()) do
        local pattern_idx = Renoise.pattern_matrix:alias_idx(self.current_mix_pattern, track_idx)
        self:set_next(track_idx, pattern_idx)
    end
end

--- set next pattern to show up
function PatternMix:set_next(track_idx, pattern_idx)
    print("called PatternMix:set_next(" .. track_idx .. ", " .. pattern_idx .. ")")
    -- get pattern
    local mix_pattern = self.next_mix_pattern
    if not mix_pattern then return end
    -- get track
    local track = mix_pattern.tracks[track_idx]
    if not track then return end
    -- set alias
    if pattern_idx == -1 then
        -- use default pattern
        local default_idx = renoise.song().sequencer:pattern(self.number_of_mix_patterns + 1)
        track.alias_pattern_index = default_idx
    else
        track.alias_pattern_index = pattern_idx
    end
end


function PatternMix:_update_current_and_next()
    self.current_mix_pattern = self:_current_mix_pattern()
    print("found current_mix_pattern at : ", self.current_mix_pattern.name)
    self.next_mix_pattern   = self:_next_mix_pattern()
    print("found next_mix_pattern at : ", self.next_mix_pattern.name)
end

-- @returns the mix pattern which should be used to alias the next pattern in.
function PatternMix:_next_mix_pattern()
    if (self.area.first.pattern and self.area.second.pattern) then
        if self.current_mix_pattern == self.area.second.pattern then
            return self.area.first.pattern
        else
            return self.area.second.pattern
        end
    end
    -- there is only one pattern mix available
    if self.area.first.pattern then
        return self.area.first.pattern
    end
    if self.area.second.pattern then
        return self.area.second.pattern
    end
end
-- @returns the mix pattern which is played right now
function PatternMix:_current_mix_pattern()
    if (self.area.first.pattern and self.area.second.pattern) then
        if renoise.song().selected_pattern == self.area.second.pattern then
            return self.area.second.pattern
        else
            return self.area.first.pattern
        end
    end
    -- there is only one pattern mix available
    if self.area.first.pattern then
        return self.area.first.pattern
    end
    if self.area.second.pattern then
        return self.area.second.pattern
    end
    return nil
end
