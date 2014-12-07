--- ======================================================================================================
---
---                                                 [ Launchpad Module ]
---
--- to connect to the launchpad and talk to it in a propper way

class "Launchpad"


LaunchpadData = {
    rotation = {
        left  = 1,
        right = 2,
    },
    --- callback convention always return an array first slot is true
    no = { flag = false }
}

require 'Layer/Launchpad/RotationLeft'
require 'Layer/Launchpad/RotationRight'

--- ======================================================================================================
---
---                                                 [ INIT ]

function Launchpad:__init()
    self:unregister_all()
    -- self:_watch()
    self.__rotation = LaunchpadData.rotation.right
end

function Launchpad:rotate_left()
    self.__rotation = LaunchpadData.rotation.left
end
function Launchpad:rotate_right()
    self.__rotation = LaunchpadData.rotation.right
end

--- connect launchpad to a midi device
--
function Launchpad:connect(midi_device_name)
    log("connect : ", midi_device_name)
    self.midi_out    = renoise.Midi.create_output_device(midi_device_name)
    --
    -- magic callback function
    local function main_callback(msg)
        if (self.__rotation == LaunchpadData.rotation.right) then
            self:right_callback(msg)
        else
            self:left_callback(msg)
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
    list[handle] = handle
end

--- unregister
--
function Launchpad:unregister_top_listener(handler)
    self:__unregister(self._top_listener, handler)
end
function Launchpad:unregister_right_listener(handler)
    self:__unregister(self._right_listener, handler)
end
function Launchpad:unregister_matrix_listener(handler)
    self:__unregister(self._matrix_listener, handler)
end
function Launchpad:unregister_all()
    self._top_listener = {}
    self._right_listener = {}
    self._matrix_listener = {}
end
function Launchpad:__unregister(list,handle)
    if list[handle] then
--        print("removed handle")
--        print(handle)
        list[handle] = nil
    else
--        print("not found")
--        print(handle)
    end
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

function Launchpad:set_side(a,color)
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
        self:set_side(x,Color.off)
    end 
end

function Launchpad:set_flash()
    self:send(0xB0,0x00,0x28)
end

function Launchpad:unset_flash()
    self:send(0xB0,0x00,0x32)
end





