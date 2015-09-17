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

    self.color[empty + set    + active   ] = BlinkColor[0][1]
    self.color[empty + set    + inactive ] = NewColor[0][1]
    self.color[empty + next   + active   ] = BlinkColor[1][1]
    self.color[empty + next   + inactive ] = NewColor[1][1]
    self.color[empty + no_mix + active   ] = NewColor[0][0]
    self.color[empty + no_mix + inactive ] = NewColor[0][0]
    self.color[full  + set    + active   ] = BlinkColor[3][0]
    self.color[full  + set    + inactive ] = NewColor[3][0]
    self.color[full  + next   + active   ] = BlinkColor[1][0]
    self.color[full  + next   + inactive ] = NewColor[1][0]
    self.color[full  + no_mix + active   ] = BlinkColor[3][2]
    self.color[full  + no_mix + inactive ] = NewColor[3][2]

    self.color_even = {}

    self.color_even[empty + set    + active   ] = BlinkColor[0][1]
    self.color_even[empty + set    + inactive ] = NewColor[0][1]
    self.color_even[empty + next   + active   ] = BlinkColor[1][1]
    self.color_even[empty + next   + inactive ] = NewColor[1][1]
    self.color_even[empty + no_mix + active   ] = NewColor[0][0]
    self.color_even[empty + no_mix + inactive ] = NewColor[0][0]
    self.color_even[full  + set    + active   ] = BlinkColor[3][0]
    self.color_even[full  + set    + inactive ] = NewColor[3][0]
    self.color_even[full  + next   + active   ] = BlinkColor[1][0]
    self.color_even[full  + next   + inactive ] = NewColor[1][0]
    self.color_even[full  + no_mix + active   ] = BlinkColor[2][3]
    self.color_even[full  + no_mix + inactive ] = NewColor[2][3]

--    self.color[empty + set    + active   ] = Color.dim.green
--    self.color[empty + set    + inactive ] = Color.empty
--    self.color[empty + next   + active   ] = Color.dim.red
--    self.color[empty + next   + inactive ] = Color.empty
--    self.color[empty + no_mix + active   ] = Color.empty
--    self.color[empty + no_mix + inactive ] = Color.empty
--    self.color[full  + set    + active   ] = Color.flash.green
--    self.color[full  + set    + inactive ] = Color.green
--    self.color[full  + next   + active   ] = Color.flash.red
--    self.color[full  + next   + inactive ] = Color.red
--    self.color[full  + no_mix + active   ] = Color.yellow
--    self.color[full  + no_mix + inactive ] = Color.yellow

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
    self:__init_patterns()
    self:__init_track()
    self:__init_pattern_matrix()
    self:__init_launchpad()
    self:__init_modes()
    self:__init_side_row()
end



function PatternMatrix:_activate()
    self:__activate_paginator()
    self:__activate_patterns()
    self:__activate_track()
    self:__activate_pattern_matrix()
    self:__activate_launchpad()
    self:__activate_modes()
    self:__activate_side_row()
end

function PatternMatrix:_deactivate()
    self:__deactivate_launchpad()
    self:__deactivate_paginator()
    self:__deactivate_patterns()
    self:__deactivate_track()
    self:__deactivate_pattern_matrix()
    self:__deactivate_modes()
    self:__deactivate_side_row()
end




---

