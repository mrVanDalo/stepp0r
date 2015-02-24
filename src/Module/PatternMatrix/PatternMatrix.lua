--- ======================================================================================================
---
---                                                 [ Pattern Matrix Module ]
---

class "PatternMatrix" (Module)

require 'Module/PatternMatrix/PatternMatrixLaunchpadMatrix'

PatternMatrixData = {
    row = {
        mix_1 = "__stepp0r_mix_1",
        mix_2 = "__stepp0r_mix_2"
    }
}

function PatternMatrix:__init()
    Module:__init(self)
    --
    self:__init_launchpad()
end

function PatternMatrix:_activate()
    self:__activate_launchpad()
    self:set_mix_to_pattern(2, 3)
    self:set_mix_to_pattern(3, 4)
    self:set_mix_to_pattern(4, 3)
    self:set_mix_to_pattern(5, 4)
end

function PatternMatrix:_deactivate()
    self:__deactivate_launchpad()
end

function PatternMatrix:wire_launchpad(pad)
    self.pad = pad
end



---

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
