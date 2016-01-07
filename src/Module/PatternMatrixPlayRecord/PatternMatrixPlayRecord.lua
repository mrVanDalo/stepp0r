--- ======================================================================================================
---
---                                                   Chooser Moudle
---
--- To record stuff in the PatternMatrixView

class "PatternMatrixPlayRecord" (Module)

require 'Module/PatternMatrixPlayRecord/PatternMatrixPlayRecordLaunchpad'

function PatternMatrixPlayRecord:__init()
    Module:__init(self)
    self.color = {
        recording     = BlinkColor[3][0],
        playing       = BlinkColor[0][3],
        not_playing   = NewColor[0][3],
    }
    --
    self:__init_launchpad()
end


function PatternMatrixPlayRecord:_activate()
    self:__activate_launchpad()
end

function PatternMatrixPlayRecord:_deactivate()
    self:__deactivate_launchpad()
end


function PatternMatrixPlayRecord:wire_launchpad(pad)
    self.pad = pad
end

