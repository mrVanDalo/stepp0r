

--- ======================================================================================================
---
---                                                 [ Delay Module ]

--- updaten an manage Delay information


class "Delay" (LaunchpadModule)





--- ======================================================================================================
---
---                                                 [ INIT ]

function Delay:__init()
    LaunchpadModule:__init(self)
    self.delay = 0
    self.callbacks_set_delay = {}
end

function Delay:wire_launchpad(pad)
    self.pad = pad
end

--- register a listener on the set delay
-- callbacks will receive a number 0-255
function Delay:register_set_delay(callback)
    table.insert(self.callbacks_set_delay,callback)
end


--- ======================================================================================================
---
---                                                 [ Boot ]

function Delay:_activate()

end

function Delay:_deactivate()

end

--- ======================================================================================================
---
---                                                 [ Library ]




--- ======================================================================================================
---
---                                                 [ Rendering ]

