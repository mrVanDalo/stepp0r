
require 'Data/Color'

--- ======================================================================================================
---
---                                                 [ Delay Module ]

--- updaten an manage Delay information


class "Delay" (LaunchpadModule)

DalayData = {

}




--- ======================================================================================================
---
---                                                 [ INIT ]

function Delay:__init()
    LaunchpadModule:__init(self)
    self.delay = 0
    self.row   = 5
    self.color = {
        on  = Color.orange,
        off = Color.off,
    }
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
    -- register row
    self.pad:register_matrix_listener(function (_,msg)
        if (msg.y ~= self.row) then return end
        self.delay = msg.x
        -- trigger callbacks
        local percent = intToPercent(self.delay)
        for _, callback in ipairs(self.callbacks_set_delay) do
            callback(percent)
        end
    end)
end

function Delay:_deactivate()

end

--- ======================================================================================================
---
---                                                 [ Library ]

--- transforms key number to percentage
-- number must be 1-8

function intToPercent(number)
    if (number < 1 ) then return 0 end
    if (number > 8 ) then return 0 end
    -- return ((256 / 8) * (number - 1) - 1)
    return (256 / 8) * (number - 1)
end


--- ======================================================================================================
---
---                                                 [ Rendering ]

