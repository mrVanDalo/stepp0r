
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
    self.delay = 1
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

-- todo : add set_instrument listener
function Delay:callback_set_instrument()
    return function (_,_)
        self:set_delay(1)
    end
end

--- ======================================================================================================
---
---                                                 [ Boot ]

function Delay:_activate()
    -- register launchpad handling
    self:matrix_refresh()
    self.pad:register_matrix_listener(function (_,msg)
        if (msg.y ~= self.row) then return end
        self:set_delay(msg.x)
    end)
end

function Delay:_deactivate()  end

--- ======================================================================================================
---
---                                                 [ Library ]

--- transforms key number to percentage
-- number must be 1-8

function intToPercent(number)
    if (number < 2 ) then return 0 end
    if (number > 8 ) then return 0 end
    -- return ((256 / 8) * (number - 1) - 1)
    return (256 / 8) * (number - 1)
end

function Delay:set_delay(delay)
    self.delay = delay
    self:matrix_refresh()
    -- trigger callbacks
    local percent = intToPercent(self.delay)
    for _, callback in ipairs(self.callbacks_set_delay) do
        callback(percent)
    end
end


--- ======================================================================================================
---
---                                                 [ Rendering ]

--- update matrix with the delay information
function Delay:matrix_update()
    self.pad:set_matrix(self.delay,self.row,self.color.on)
end
function Delay:matrix_clear()
    for i = 1, 8 do
        self.pad:set_matrix(i, self.row,self.color.off)
    end
end
function Delay:matrix_refresh()
    self:matrix_clear()
    self:matrix_update()
end

