--- ======================================================================================================
---
---                                                 [ Pattern Matrix Module ]
---

class "PatternMatrix" (Module)

require 'Module/PatternMatrix/PatternMatrixLaunchpadMatrix'
require 'Module/PatternMatrix/PatternMatrixPatternMix'
require 'Module/PatternMatrix/PatternMatrixPatternMatrix'
require 'Module/PatternMatrix/PatternMatrixPaginator'
require 'Module/PatternMatrix/PatternMatrixModes'
require 'Module/PatternMatrix/PatternMatrixIT_Selection'
require 'Module/PatternMatrix/PatternMatrixSideRow'

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
            inactive = 200,
            group_a  = 0,
            group_b  = 300,
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
    local group_a  = PatternMatrixData.matrix.state.group_a
    local group_b  = PatternMatrixData.matrix.state.group_b

    self.color[empty + set    + active   + group_a ] = BlinkColor[0][1]
    self.color[empty + set    + inactive + group_a ] = NewColor[0][1]
    self.color[empty + next   + active   + group_a ] = BlinkColor[1][1]
    self.color[empty + next   + inactive + group_a ] = NewColor[1][1]
    self.color[empty + no_mix + active   + group_a ] = NewColor[0][0]
    self.color[empty + no_mix + inactive + group_a ] = NewColor[0][0]
    self.color[full  + set    + active   + group_a ] = BlinkColor[3][0]
    self.color[full  + set    + inactive + group_a ] = NewColor[3][0]
    self.color[full  + next   + active   + group_a ] = BlinkColor[1][0]
    self.color[full  + next   + inactive + group_a ] = NewColor[1][0]
    self.color[full  + no_mix + active   + group_a ] = BlinkColor[3][2]
    self.color[full  + no_mix + inactive + group_a ] = NewColor[3][2]
    self.color[empty + set    + active   + group_b ] = BlinkColor[0][1]
    self.color[empty + set    + inactive + group_b ] = NewColor[0][1]
    self.color[empty + next   + active   + group_b ] = BlinkColor[1][1]
    self.color[empty + next   + inactive + group_b ] = NewColor[1][1]
    self.color[empty + no_mix + active   + group_b ] = NewColor[0][0]
    self.color[empty + no_mix + inactive + group_b ] = NewColor[0][0]
    self.color[full  + set    + active   + group_b ] = BlinkColor[3][0]
    self.color[full  + set    + inactive + group_b ] = NewColor[3][0]
    self.color[full  + next   + active   + group_b ] = BlinkColor[1][0]
    self.color[full  + next   + inactive + group_b ] = NewColor[1][0]
    self.color[full  + no_mix + active   + group_b ] = BlinkColor[2][3]
    self.color[full  + no_mix + inactive + group_b ] = NewColor[2][3]

end

function PatternMatrix:__init()
    Module:__init(self)
    --
    self:__create_color_map()
    self.mode_color = {
        clear = Color.red,
        copy  = Color.orange,
        mix   = Color.green,
    }
    --
    self:__init_paginator()
    self:__init_pattern_mix()
    self:__init_it_selection()
    self:__init_pattern_matrix()
    self:__init_launchpad()
    self:__init_modes()
    self:__init_side_row()
end



function PatternMatrix:_activate()
    self:__activate_paginator()
    self:__activate_pattern_mix()
    self:__activate_it_selection()
    self:__activate_pattern_matrix()
    self:__activate_launchpad()
    self:__activate_modes()
    self:__activate_side_row()
end

function PatternMatrix:_deactivate()
    self:__deactivate_launchpad()
    self:__deactivate_paginator()
    self:__deactivate_pattern_mix()
    self:__deactivate_it_selection()
    self:__deactivate_pattern_matrix()
    self:__deactivate_modes()
    self:__deactivate_side_row()
end




---

