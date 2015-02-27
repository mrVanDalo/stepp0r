--- ======================================================================================================
---
---                                                 [ Pattern Matrix Module ]
---

class "PatternMatrix" (Module)

require 'Module/PatternMatrix/PatternMatrixLaunchpadMatrix'
require 'Module/PatternMatrix/PatternMatrixPatterns'
require 'Module/PatternMatrix/PatternMatrixPatternMatrix'
require 'Module/PatternMatrix/PatternMatrixPaginator'
require 'Module/PatternMatrix/PatternMatrixTrack'

PatternMatrixData = {
    row = {
        mix_1 = "__stepp0r_mix_1",
        mix_2 = "__stepp0r_mix_2"
    },
    matrix = {
        access = {
            state = 1,
            pattern_idx = 2,
        },
        state = {
            empty = 1,
            full  = 2
        },
    },

}

function PatternMatrix:__init()
    Module:__init(self)
    self.color = {
        full  = Color.green,
        empty = Color.off
    }
    --
    self:__init_paginator()
    self:__init_patterns()
    self:__init_track()
    self:__init_pattern_matrix()
    self:__init_launchpad()
end


function PatternMatrix:_activate()
    self:__activate_paginator()
    self:__activate_patterns()
    self:__activate_track()
    self:__activate_pattern_matrix()
    self:__activate_launchpad()
end

function PatternMatrix:_deactivate()
    self:__deactivate_launchpad()
    self:__deactivate_paginator()
    self:__deactivate_patterns()
    self:__deactivate_track()
    self:__deactivate_pattern_matrix()
end




---

