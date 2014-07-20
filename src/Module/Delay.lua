

--- ======================================================================================================
---
---                                                 [ Delay Module ]

--- updaten an manage Delay information


class "Delay"







--- ======================================================================================================
---
---                                                 [ INIT ]

function Delay:__init()
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



