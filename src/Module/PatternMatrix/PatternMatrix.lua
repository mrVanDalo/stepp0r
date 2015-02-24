--- ======================================================================================================
---
---                                                 [ Pattern Matrix Module ]
---

class "PatternMatrix" (Module)

PatternMatrixData = {
    row = {
        prefix = "__stepp0r_mix_"
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

