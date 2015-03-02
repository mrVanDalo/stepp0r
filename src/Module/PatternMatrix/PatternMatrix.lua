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
            set      = 10,
            next     = 20,
            no_mix   = 30,
            active   = 100,
            inactive = 200
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

    local empty    = PatternMatrixData.matrix.state.empty
    local full     = PatternMatrixData.matrix.state.full
    local set      = PatternMatrixData.matrix.state.set
    local next     = PatternMatrixData.matrix.state.next
    local no_mix   = PatternMatrixData.matrix.state.no_mix
    local active   = PatternMatrixData.matrix.state.active
    local inactive = PatternMatrixData.matrix.state.inactive

    self.color[empty + set    + active   ] = Color.dim.green
    self.color[empty + set    + inactive ] = Color.empty
    self.color[empty + next   + active   ] = Color.dim.red
    self.color[empty + next   + inactive ] = Color.empty
    self.color[empty + no_mix + active   ] = Color.dim.green
    self.color[empty + no_mix + inactive ] = Color.empty
    self.color[full  + set    + active   ] = Color.flash.green
    self.color[full  + set    + inactive ] = Color.green
    self.color[full  + next   + active   ] = Color.flash.red
    self.color[full  + next   + inactive ] = Color.red
    self.color[full  + no_mix + active   ] = Color.yellow
    self.color[full  + no_mix + inactive ] = Color.yellow

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

