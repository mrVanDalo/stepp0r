--- ======================================================================================================
---
---                                                 [ Pattern Matrix Module ]
---

class "PatternMatrix" (Module)

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
end

function PatternMatrix:_deactivate()
    self:__deactivate_launchpad()
end

function PatternMatrix:wire_launchpad(pad)
    self.pad = pad
end



---

function PatternMatrix:find_mix_row()
    local pattern_size = table.size(renoise.song().patterns)
    for pattern_idx = 1, pattern_size do
        local pattern = renoise.song().patterns[pattern_idx]
        if pattern.name == PatternMatrixData.row.mix_1 then
            return pattern
        end
    end
    return nil
end
