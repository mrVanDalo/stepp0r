--- ======================================================================================================
---
---                                                 [ Pattern Matrix Module ]
---

class "PatternMatrix" (Module)

require 'Module/PatternMatrix/PatternMatrixLaunchpadMatrix'
require 'Module/PatternMatrix/PatternMatrixPatterns'
require 'Module/PatternMatrix/PatternMatrixPaginator'
require 'Module/PatternMatrix/PatternMatrixTrack'

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
    self:__init_paginator()
    self:__init_patterns()
    self:__init_track()
end


function PatternMatrix:_activate()
    self:__activate_launchpad()
    self:__activate_paginator()
    self:__activate_patterns()
    self:__activate_track()
end

function PatternMatrix:_deactivate()
    self:__deactivate_launchpad()
    self:__deactivate_paginator()
    self:__deactivate_patterns()
    self:__deactivate_track()
end

function PatternMatrix:wire_launchpad(pad)
    self.pad = pad
end



---

