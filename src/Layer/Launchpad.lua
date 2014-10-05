
require 'Data/Color'

--- ======================================================================================================
---
---                                                 [ Launchpad Module ]
---
--- to connect to the launchpad and talk to it in a propper way

-- todo move me to module (or Layer)
class "Launchpad"

--- ======================================================================================================
---
---                                                 [ INIT ]

function Launchpad:__init()
    self:unregister_all()
    -- self:_watch()
end

-- watches for launchpad connections
-- (should handle all the reconnection stuff and all)
-- will be removed by another component soon
-- todo remove me by ui
function Launchpad:_watch()
    for _,v in pairs(renoise.Midi.available_input_devices()) do
        if string.find(v, "Launchpad") then
            self:connect(v)
        end
    end
end

--- connect launchpad to a midi device
--
function Launchpad:connect(midi_device_name)
    print("connect : " ..  midi_device_name)
    self.midi_out    = renoise.Midi.create_output_device(midi_device_name)
    --
    -- magic callback function
    local function main_callback(msg)
        local result = _is_matrix(msg)
        if (result.flag) then
            for _, callback in ipairs(self._matrix_listener) do
                callback(self, result)
            end
            return
        end
        --
        result = _is_top(msg)
        if (result.flag) then
            for _, callback in ipairs(self._top_listener) do
                callback(self, result)
            end
            return
        end
        --
        result = _is_right(msg)
        if (result.flag) then
            for _, callback in ipairs(self._right_listener) do
                callback(self, result)
            end
            return
        end
    end
    self.midi_input  = renoise.Midi.create_input_device(midi_device_name, main_callback)
end

function Launchpad:disconnect()
    if self.midi_input then
        self.midi_input:close()
        self.midi_input = nil
    end
    if self.midi_out then
        self.midi_out:close()
        self.midi_out = nil
    end
end


--- ======================================================================================================
---
---                                                 [ Output ]

--- register handler functions
--
function Launchpad:register_top_listener(handler)
    self:_register(self._top_listener,   handler)
end
function Launchpad:register_right_listener(handler)
    self:_register(self._right_listener, handler)
end
function Launchpad:register_matrix_listener(handler)
    self:_register(self._matrix_listener,handler)
end
function Launchpad:_register(list,handle)
    -- print("register")
    table.insert(list,handle)
end

--- unregister
--
function Launchpad:unregister_top_listener()
    self._top_listener = {}
end
function Launchpad:unregister_right_listener()
    self._right_listener = {}
end
function Launchpad:unregister_matrix_listener()
    self._matrix_listener = {}
end
function Launchpad:unregister_all()
    self:unregister_top_listener()
    self:unregister_right_listener()
    self:unregister_matrix_listener()
end

--- callback convention always return an array first slot is true
no = { flag = false }

--- Test functions for the handler
--
function _is_top(msg)
    if msg[1] == 0xB0 then
        local x = msg[2] - 0x68 
        if (x > -1 and x < 8) then
            return { flag = true,  x = (x + 1), vel = msg[3] }
        end
    end
    return no
end
function _is_right(msg)
    if msg[1] == 0x90 then
        local note = msg[2]
        if (bit.band(0x08,note) == 0x08) then
            local x = bit.rshift(note,4)
            if (x > -1 and x < 8) then 
                return { flag = true,  x = (x + 1), vel = msg[3] }
            end
        end
    end
    return no 
end
function _is_matrix(msg)
    if msg[1] == 0x90 then
        local note = msg[2]
        if (bit.band(0x08,note) == 0) then
            local y = bit.rshift(note,4)
            local x = bit.band(0x07,note)
            if ( x > -1 and x < 8 and y > -1  and y < 8 ) then 
                return { flag = true , x = (x + 1) , y = (y + 1), vel = msg[3] }
            end
        end
    end
    return no
end



--- ======================================================================================================
---
---                                                 [ Input ]

function Launchpad:send(channel, number, value)
    if (not self.midi_out or not self.midi_out.is_open) then
    --    print("midi is not open")
        return
    end
    local message = {channel, number, value}
    -- print(("Launchpad : send MIDI %X %X %X"):format(message[1], message[2], message[3]))
    self.midi_out:send(message)
end

function Launchpad:set_matrix( a, b , color )
    local x = a - 1
    local y = b - 1
    if ( x < 8 and x > -1 and y < 8 and y > -1) then
        self:send(0x90 , y * 16 + x , color)
    end
end

function Launchpad:set_top(a,color)
    local x = a - 1
    if ( x > -1 and x < 8 ) then
        self:send( 0xB0, x + 0x68, color)
    end
end

function Launchpad:set_right(a,color)
    local x = a - 1
    if ( x > -1 and x < 8 ) then
        self:send( 0x90, 0x10 * x + 0x08, color)
    end
end

function Launchpad:clear()
    self:clear_matrix()
    self:clear_top()
    self:clear_right()
end

function Launchpad:clear_matrix()
    for x=0,7,1 do 
        for y=0,7,1 do 
            self:set_matrix(x,y,Color.off)
        end 
    end 
end

function Launchpad:clear_right()
    for x=0,7,1 do 
        self:set_top(x,Color.off)
    end 
end

function Launchpad:clear_top()
    for x=0,7,1 do 
        self:set_right(x,Color.off)
    end 
end

function Launchpad:set_flash()
    self:send(0xB0,0x00,0x28)
end

function Launchpad:unset_flash()
    self:send(0xB0,0x00,0x32)
end





--- ======================================================================================================
---
---                                                 [ Examples ]

--- example handler
--
function echo_top(_,msg)
    local x   = msg.x
    local vel = msg.vel
    --print(top)
    print(("top    : (%X) = %X"):format(x,vel))
end
function echo_right(_,msg)
    local x   = msg.x
    local vel = msg.vel
    --print(right)
    print(("right  : (%X) = %X"):format(x,vel))
end
function echo_matrix(_,msg)
    local x   = msg.x
    local y   = msg.y
    local vel = msg.vel
    --print(matrix)
    print(("matrix : (%X,%X) = %X"):format(x,y,vel))
end


--- example functions
--
function example_matrix(pad)
    for y=0,7,1 do 
        for x=0,7,1 do 
            pad:set_matrix(x,y,x+(y*8))
        end 
    end 
end
function example_colors(pad)
    -- send
    -- configuration
    pad:set_flash()

    pad:set_matrix(i,1,Color.red)
    pad:set_matrix(1,1,Color.yellow)
    pad:set_matrix(2,1,Color.green)
    pad:set_matrix(3,1,Color.orange)

    pad:set_matrix(4,2,Color.flash.red)
    pad:set_matrix(1,2,Color.flash.yellow)
    pad:set_matrix(2,2,Color.flash.green)
    pad:set_matrix(3,2,Color.flash.orange)
   
    pad:set_matrix(3,3,Color.full.red)
    pad:set_matrix(1,3,Color.full.yellow)
    pad:set_matrix(2,3,Color.full.green)

    pad:set_matrix(3,4,Color.dim.red)
    pad:set_matrix(1,4,Color.dim.yellow)
    pad:set_matrix(2,4,Color.dim.green)

    pad:set_top(1,Color.yellow)
    pad:set_top(2,Color.green)
    pad:set_top(3,Color.orange)
    pad:set_top(4,Color.flash.red)
    pad:set_top(5,Color.flash.yellow)
    pad:set_top(6,Color.flash.green)
    pad:set_top(7,Color.flash.orange)
    pad:set_top(8,Color.red)

    pad:set_right(8,Color.red)
    pad:set_right(1,Color.yellow)
    pad:set_right(2,Color.green)
    pad:set_right(3,Color.orange)
    pad:set_right(4,Color.flash.red)
    pad:set_right(5,Color.flash.yellow)
    pad:set_right(6,Color.flash.green)
    pad:set_right(7,Color.flash.orange)

    -- callbacks
    pad:unregister_all()

    pad:register_matrix_listener(echo_matrix)
    pad:register_top_listener(echo_top)
    pad:register_right_listener(echo_right)
end
function example(pad)
    -- configuration
    example_colors(pad)
end


