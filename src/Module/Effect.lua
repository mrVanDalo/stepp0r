
require 'Data/Color'
require 'Data/Velocity'

--- ======================================================================================================
---
---                                                 [ Effect Module ]

--- updaten an manage Effect information


class "Effect" (LaunchpadModule)

EffectData = {
    mode = {
        DELAY  = {1, Color.green },
        PAN    = {2, Color.red   },
        VOLUME = {3, Color.orange},
    },
    access = {
        color = 2,
    }
}




--- ======================================================================================================
---
---                                                 [ INIT ]

function Effect:__init()
    LaunchpadModule:__init(self)
    self.mode  = EffectData.mode.DELAY
    self.delay = 1 -- init values
    self.pan   = 0 -- init values
    self.vol   = 1 -- init values
    -- configuration
    self.row           = 5
    self.mode_knob_idx = self.row
    self.color = {
        on  = Color.orange,
        off = Color.off,
    }
    self.callbacks_set_delay  = {}
    self.callbacks_set_pan    = {}
    self.callbacks_set_volume = {}
end

function Effect:wire_launchpad(pad)
    self.pad = pad
end

--- register a listener on the set delay
-- callbacks will receive a number 0-255
function Effect:register_set_delay(callback)
    table.insert(self.callbacks_set_delay,callback)
end
--- register a listener on the set pan
-- callbacks will receive a number 0-127
-- 64 is the center
function Effect:register_set_pan(callback)
    table.insert(self.callbacks_set_pan,callback)
end
--- register a listener on the set volume
-- callbacks will receive a number 0-127
function Effect:register_set_volume(callback)
    table.insert(self.callbacks_set_volume,callback)
end

function Effect:callback_set_instrument()
    return function (_,_)
        self:set_delay(1)
        self:set_volume(1)
        self:set_pan(0)
    end
end

--- ======================================================================================================
---
---                                                 [ Boot ]

function Effect:_activate()
    self:refresh()
    -- matrix
    self.pad:register_matrix_listener(function (_,msg)
        if (msg.vel == Velocity.release) then return end
        if (msg.y ~= self.row)           then return end
        if     self.mode == EffectData.mode.DELAY  then self:set_delay(msg.x)
        elseif self.mode == EffectData.mode.VOLUME then self:set_volume(msg.x)
        else                                            self:set_pan(msg.x)
        end
    end)
    -- right
    self.pad:register_right_listener(function (_,msg)
        if (msg.vel == Velocity.release) then return end
        if (msg.x ~= self.mode_knob_idx) then return end
        self:next_mode()
    end)

end

function Effect:_deactivate()  end

--- ======================================================================================================
---
---                                                 [ Library ]

--- transforms key number to percentage
-- number must be 1-8

function xToDelay(number)
    if (number < 2 ) then return 0 end
    if (number > 8 ) then return 0 end
    -- return ((256 / 8) * (number - 1) - 1)
    return (256 / 8) * (number - 1)
end

function Effect:set_delay(delay)
    self.delay = delay
    self:matrix_refresh()
    -- trigger callbacks
    local percent = xToDelay(self.delay)
    for _, callback in ipairs(self.callbacks_set_delay) do
        callback(percent)
    end
end

--- transforms key number to paning
-- number must be 0-8
function xToPan(number)
    if number < 1 or number > 8 then return 64 end
    -- todo write this correct
    return ((number - 1) * 18)
end
function Effect:set_pan(pan)
    self.pan = pan
    self:matrix_refresh()
    -- trigger callbacks
    local percent = xToPan(self.volume)
    for _, callback in ipairs(self.callbacks_set_pan) do
        callback(percent)
    end
end

--- transforms key number to volume
-- number must be 1-8
function xToVolume(number)
    if number < 1 or number > 8 then return 127 end
    return (number  * 16) - 1
end
function Effect:set_volume(volume)
    self.volume = volume
    self:matrix_refresh()
    -- trigger callbacks
    local percent = xToVolume(self.volume)
    for _, callback in ipairs(self.callbacks_set_volume) do
        callback(percent)
    end
end

function Effect:next_mode()
    if     self.mode == EffectData.mode.DELAY then self.mode = EffectData.mode.PAN
    elseif self.mode == EffectData.mode.PAN   then self.mode = EffectData.mode.VOLUME
    else                                           self.mode = EffectData.mode.DELAY    end
    self:right_refresh()
    self:matrix_refresh()
end

--- ======================================================================================================
---
---                                                 [ Rendering ]

--- update matrix with the delay information
function Effect:matrix_update_delay()
    self.pad:set_matrix(self.delay,self.row,self.color.on)
end
function Effect:matrix_update_volume()
    for i = 1, 8 do
        local color = self.color.off
        if (self.volume >= i) then color = self.color.on end
        self.pad:set_matrix(i,self.row,color)
    end
end
function Effect:matrix_update_pan()
    if self.pan == 0 then return end
    if self.pan < 5 then
        for i = 1, 4 do
            local color = self.color.off
            if self.pan >= i then color = self.color.on end
            self.pad:set_matrix(self.i,self.row,color)
        end
    else
        for i = 5, 8 do
            local color = self.color.off
            if self.pan <= i then color = self.color.on end
            self.pad:set_matrix(self.i,self.row,color)
        end
    end
end

function Effect:matrix_clear()
    for i = 1, 8 do
        self.pad:set_matrix(i, self.row,self.color.off)
    end
end
function Effect:matrix_refresh()
    self:matrix_clear()
    if self.mode == EffectData.mode.DELAY then
        self:matrix_update_delay()
    elseif self.mode == EffectData.mode.PAN then
        self:matrix_update_pan()
    else
        self:matrix_update_volume()
    end
end

function Effect:right_refresh()
    self.pad:set_right(self.mode_knob_idx,self.mode[EffectData.access.color])
end

function Effect:refresh()
    self:matrix_refresh()
    self:right_refresh()
end

