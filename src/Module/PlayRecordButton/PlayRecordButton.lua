--- ======================================================================================================
---
---                                                   Play Record Button
---
--- A button to play record and stop

class "PlayRecordButton" (Module)

require 'Module/PlayRecordButton/PlayRecordButtonLaunchpad'

function PlayRecordButton:__init()
    Module:__init(self)
    self.color = {
        recording     = BlinkColor[3][0],
        playing       = BlinkColor[0][3],
        not_playing   = NewColor[0][3],
    }
    --
    self:__init_launchpad()
end


function PlayRecordButton:_activate()
    self:__activate_launchpad()
end

function PlayRecordButton:_deactivate()
    self:__deactivate_launchpad()
end

function PlayRecordButton:wire_launchpad(pad)
    self.pad = pad
end



