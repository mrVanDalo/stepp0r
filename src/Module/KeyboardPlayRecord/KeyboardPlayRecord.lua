--- ======================================================================================================
---
---                                                   Chooser Moudle
---
--- To record keyboard stuff

class "KeyboardPlayRecord" (Module)

require 'Module/KeyboardPlayRecord/KeyboardPlayRecordLaunchpad'

function KeyboardPlayRecord:__init()
    Module:__init(self)
    self.color = {
        recording     = BlinkColor[3][0],
        not_recording = NewColor[3][0],
        playing       = BlinkColor[0][3],
        not_playing   = NewColor[0][3],
    }
    --
    self:__init_launchpad()
end


function KeyboardPlayRecord:_activate()
    self:__activate_launchpad()
end

function KeyboardPlayRecord:_deactivate()
    self:__deactivate_launchpad()
end


function KeyboardPlayRecord:wire_launchpad(pad)
    self.pad = pad
end

