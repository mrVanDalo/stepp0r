

--- ====================================================================================================
--- Pattern Mix Area
--
-- This is the area up there where the play loop is happening


function PatternMix:__init_area()

    self.area = {
        first = {
            pattern = nil,
            idx     = nil,  -- sequence_idx
        },
        second = {
            pattern = nil,
            idx     = nil,  -- sequence_idx
        },
    }

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
    self:__ensure_area_exist()
    self:__set_area()
end
function PatternMix:__deactivate_area()
    self:__remove_area()
end

function PatternMix:set_number_of_mix_patterns(number)
    self.number_of_mix_patterns = number
end


function PatternMix:__set_area()
    local tupel = self:__find_mix_pattern(PatternMixData.row.mix_1)
    if tupel then
        self.area.first = {
            pattern = tupel[2],
            idx     = tupel[1]
        }
    else
        self.area.first = {
            pattern = nil,
            idx     = nil,
        }
    end
    local tupel_2 = self:__find_mix_pattern(PatternMixData.row.mix_2)
    if tupel_2 then
        self.area.second = {
            pattern = tupel_2[2],
            idx     = tupel_2[1]
        }
    else
        self.area.second = {
            pattern = nil,
            idx     = nil,
        }
    end
end
function PatternMix:__find_mix_pattern(key)
    for sequence_idx,pattern_idx in pairs(renoise.song().sequencer.pattern_sequence) do
        local pattern = renoise.song().patterns[pattern_idx]
        if pattern.name == key then
            -- todo : use the first and second object format here
            return {sequence_idx, pattern}
        end
    end
    return nil
end

function PatternMix:__ensure_area_exist()
    self:__remove_area()
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
    renoise.song().sequencer:set_sequence_section_name(1, self.mix_pattern_title)
    renoise.song().sequencer:set_sequence_is_start_of_section(1,true)
    renoise.song().selected_sequence_index = 1
end

function PatternMix:__remove_area()
    self:__set_area()
    if self.area.second.idx then
        renoise.song().sequencer:delete_sequence_at(self.area.second.idx)
    end
    if self.area.first.idx then
        renoise.song().sequencer:delete_sequence_at(self.area.first.idx)
    end
    renoise.song().sequencer:set_sequence_is_start_of_section(1,false)
    renoise.song().transport.loop_sequence_range = {0,0}
end
