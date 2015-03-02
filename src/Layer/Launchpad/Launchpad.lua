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
--    self.__rotatio__create_midi_input_callbackn = LaunchpadData.rotation.left
    self:__create_midi_input_callback()
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
    self.midi_out    = renoise.Midi.create_output_device(midi_device_name)
    self.midi_input  = renoise.Midi.create_input_device(midi_device_name, self.__midi_input_callback)
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

function Launchpad:__create_midi_input_callback()
    self.__midi_input_callback = function (msg)
        if (self.__rotation == LaunchpadData.rotation.right) then
            self:_right_callback(msg)
        else
            self:_left_callback(msg)
        end
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
function Launchpad:register_side_listener(handler)
    self:_register(self._side_listener, handler)
end
function Launchpad:register_matrix_listener(handler)
    self:_register(self._matrix_listener,handler)
end
function Launchpad:_register(list,handle)
    list[handle] = handle
end

--- unregister
--
function Launchpad:unregister_top_listener(handler)
    self:__unregister(self._top_listener, handler)
end
function Launchpad:unregister_side_listener(handler)
    self:__unregister(self._side_listener, handler)
end
function Launchpad:unregister_matrix_listener(handler)
    self:__unregister(self._matrix_listener, handler)
end
function Launchpad:unregister_all()
    self._top_listener = {}
    self._side_listener = {}
    self._matrix_listener = {}
end
function Launchpad:__unregister(list,handle)
    if list[handle] then
        list[handle] = nil
    end
end



--- ======================================================================================================
---
---                                                 [ Input ]

function Launchpad:send(channel, number, value)
    if (not self.midi_out or not self.midi_out.is_open) then
        return
    end
    local message = {channel, number, value}
    -- print(("Launchpad : send MIDI %X %X %X"):format(message[1], message[2], message[3]))
    self.midi_out:send(message)
end

function Launchpad:set_matrix( a, b , color )
    if (self.__rotation == LaunchpadData.rotation.right) then
        self:_set_matrix_right(a,b,color)
    else
        self:_set_matrix_left(a,b,color)
    end
end

function Launchpad:set_top(a,color)
    if (self.__rotation == LaunchpadData.rotation.right) then
        self:_set_top_right(a,color)
    else
        self:_set_top_left(a,color)
    end
end

function Launchpad:set_side(a,color)
    if (self.__rotation == LaunchpadData.rotation.right) then
        self:_set_side_right(a,color)
    else
        self:_set_side_left(a,color)
    end
end

function Launchpad:clear()
    self:clear_matrix()
    self:clear_top()
    self:clear_side()
end

function Launchpad:clear_matrix()
    for x=0,7,1 do 
        for y=0,7,1 do 
            self:set_matrix(x,y,Color.off)
        end 
    end 
end
function Launchpad:clear_side()
    for x=0,7,1 do 
        self:set_side(x,Color.off)
    end 
end
function Launchpad:clear_top()
    for x=0,7,1 do 
        self:set_top(x,Color.off)
    end 
end

function Launchpad:set_flash()
    self:send(0xB0,0x00,0x28)
end
function Launchpad:unset_flash()
    self:send(0xB0,0x00,0x32)
end





