color = {

    red    = 0x07,
    orange = 0x27,
    yellow = 0x3F,
    green  = 0x3C,

    flash = {
        red    = 0x03,
        orange = 0x23,
        yellow = 0x73,
        green  = 0x70,
        off    = 0x00,
    },
    full = {
        red    = 0x07,
        yellow = 0x3F,
        green  = 0x3C,
    },
    dim = {
        red    = 0x0E,
        yellow = 0x2E,
        green  = 0x2C,
    },
    off = 12
}

-- Launchpad class.
--
class "Launchpad"

function Launchpad:__init()
    self:_watch()
end

function Launchpad:_watch()
    for k,v in pairs(renoise.Midi.available_input_devices()) do
        if string.find(v, "Launchpad") then
            self:_connect(v)
        end
    end
end

function Launchpad:_connect(midi_device_name)
    print("connect : " ..  midi_device_name)
    -- self.midi_input  = renoise.Midi.create_input_device(device_name [,callback] [, sysex_callback])
    self.midi_out = renoise.Midi.create_output_device(midi_device_name)
end

function Launchpad:send(channel, number, value)
    --if (not self.midi_out or not self.midi_out.is_open) then
    --    print("midi is not open")
    --    return
    --end

    local message = {channel, number, value}

    print(("Launchpad : send MIDI %X %X %X"):format(message[1], message[2], message[3]))
    
    self.midi_out:send(message)
end

function Launchpad:set_matrix( x, y , color )
    if ( x < 8 and x > -1 and y < 8 and y > -1) then
        self:send(0x90 , y * 16 + x , color)
    end
end

function Launchpad:set_top(x,color)
    if ( x > -1 and x < 8 ) then
        self:send( 0xB0, x + 0x68, color)
    end
end

function Launchpad:set_right(x,color)
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
            self:set_matrix(x,y,color.off)
        end 
    end 
end

function Launchpad:clear_right()
    for x=0,7,1 do 
        self:set_top(x,color.off)
    end 
end

function Launchpad:clear_top()
    for x=0,7,1 do 
        self:set_right(x,color.off)
    end 
end

function Launchpad:set_flash(value)
    if (value) then
        self:send(0xB0,0x00,0x28)
    else
        self:send(0xB0,0x00,0x32)
    end
end

-- ------------------------------------------------------------
-- example functions

function example_matrix(pad)
    for y=0,7,1 do 
        for x=0,7,1 do 
            pad:set_matrix(x,y,x+(y*8))
        end 
    end 
end

function example_colors(pad)
    pad:set_flash(true)

    pad:set_matrix(0,0,color.red)
    pad:set_matrix(1,0,color.yellow)
    pad:set_matrix(2,0,color.green)
    pad:set_matrix(3,0,color.orange)

    pad:set_matrix(0,1,color.flash.red)
    pad:set_matrix(1,1,color.flash.yellow)
    pad:set_matrix(2,1,color.flash.green)
    pad:set_matrix(3,1,color.flash.orange)
   
    pad:set_matrix(0,2,color.full.red)
    pad:set_matrix(1,2,color.full.yellow)
    pad:set_matrix(2,2,color.full.green)

    pad:set_matrix(0,3,color.dim.red)
    pad:set_matrix(1,3,color.dim.yellow)
    pad:set_matrix(2,3,color.dim.green)

    pad:set_top(0,color.red)
    pad:set_top(1,color.yellow)
    pad:set_top(2,color.green)
    pad:set_top(3,color.orange)
    pad:set_top(4,color.flash.red)
    pad:set_top(5,color.flash.yellow)
    pad:set_top(6,color.flash.green)
    pad:set_top(7,color.flash.orange)

    pad:set_right(0,color.red)
    pad:set_right(1,color.yellow)
    pad:set_right(2,color.green)
    pad:set_right(3,color.orange)
    pad:set_right(4,color.flash.red)
    pad:set_right(5,color.flash.yellow)
    pad:set_right(6,color.flash.green)
    pad:set_right(7,color.flash.orange)
end


