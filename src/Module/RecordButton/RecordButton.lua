--- ======================================================================================================
---
---                                                   Chooser Moudle
---
--- To record keyboard stuff

class "RecordButton" (Module)


require 'Module/RecordButton/RecordButtonLaunchpad'
require 'Module/RecordButton/RecordButtonLib'

function RecordButton:__init()
    Module:__init(self)
    self.color = {
        recording     = BlinkColor[3][0],
        not_recording = NewColor[3][0],
        playing       = BlinkColor[0][3],
        not_playing   = NewColor[0][3],
    }
    --
    self:__init_launchpad()
    self:__init_lib()
end


function RecordButton:_activate()
    self:__activate_launchpad()
    self:__activate_lib()
end

function RecordButton:_deactivate()
    self:__deactivate_lib()
    self:__deactivate_launchpad()
end


function RecordButton:wire_launchpad(pad)
    self.pad = pad
end

