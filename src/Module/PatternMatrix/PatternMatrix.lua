--- ======================================================================================================
---
---                                                 [ Pattern Matrix Module ]
---

class "PatternMatrix" (Module)

require 'Module/PatternMatrix/PatternMatrixLaunchpadMatrix'
require 'Module/PatternMatrix/PatternMatrixPatterns'
require 'Module/PatternMatrix/PatternMatrixPatternMatrix'
require 'Module/PatternMatrix/PatternMatrixPaginator'
require 'Module/PatternMatrix/PatternMatrixModes'
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
            empty    = 0,
            full     = 1,
            set      = 2,
            next     = 3,
            active   = 10,
            inactive = 20
        },
    },
    mode = {
        clear = 1,
        copy  = 2,
        mix   = 3,
    },

}

function PatternMatrix:__create_color_map()
    self.color = {}
    self.color[ PatternMatrixData.matrix.state.empty + PatternMatrixData.matrix.state.active   ] = Color.empty
    self.color[ PatternMatrixData.matrix.state.empty + PatternMatrixData.matrix.state.inactive ] = Color.empty
    self.color[ PatternMatrixData.matrix.state.full  + PatternMatrixData.matrix.state.active   ] = Color.yellow
    self.color[ PatternMatrixData.matrix.state.full  + PatternMatrixData.matrix.state.inactive ] = Color.yellow
    self.color[ PatternMatrixData.matrix.state.set   + PatternMatrixData.matrix.state.active   ] = Color.flash.green
    self.color[ PatternMatrixData.matrix.state.set   + PatternMatrixData.matrix.state.inactive ] = Color.green
    self.color[ PatternMatrixData.matrix.state.next  + PatternMatrixData.matrix.state.active   ] = Color.flash.orange
    self.color[ PatternMatrixData.matrix.state.next  + PatternMatrixData.matrix.state.inactive ] = Color.orange
end
function PatternMatrix:__init()
    Module:__init(self)
    --
    self:__create_color_map()
    self.mode_color = {
        clear = Color.red,
        copy  = Color.flash.red,
        mix   = Color.green,
    }
    --
    self:__init_paginator()
    self:__init_patterns()
    self:__init_track()
    self:__init_pattern_matrix()
    self:__init_launchpad()
    self:__init_modes()
end


function PatternMatrix:_activate()
    self:__activate_paginator()
    self:__activate_patterns()
    self:__activate_track()
    self:__activate_pattern_matrix()
    self:__activate_launchpad()
    self:__activate_modes()
end

function PatternMatrix:_deactivate()
    self:__deactivate_launchpad()
    self:__deactivate_paginator()
    self:__deactivate_patterns()
    self:__deactivate_track()
    self:__deactivate_pattern_matrix()
    self:__deactivate_modes()
end




---

