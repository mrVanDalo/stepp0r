
require 'LaunchpadMode'

-- --
-- Keyboard Mode 
--
class "Keyboard" (LaunchpadMode)

function Keyboard:__init(pad)
  LaunchpadMode:__init(self,pad)
end

function Keyboard:_activate()
  print ("hallo")
    -- pass
end

function Keyboard:_deactivate()
  print("du")
    -- pass
end
