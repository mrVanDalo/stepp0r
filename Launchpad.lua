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

-- ============================================================
--                                                    Launchpad

class "Launchpad"

function Launchpad:__init()
    self.handler = {}
    self:_watch()
end

-- ------------------------------------------------------------
--                                          connection handling

-- watches for launchpad connections
-- (should handle all the reconnection stuff and all)
-- will be removed by another component soon
function Launchpad:_watch()
    for k,v in pairs(renoise.Midi.available_input_devices()) do
        if string.find(v, "Launchpad") then
            self:_connect(v)
        end
    end
end

function Launchpad:_connect(midi_device_name)
    print("connect : " ..  midi_device_name)
    self.midi_out    = renoise.Midi.create_output_device(midi_device_name)
    -- self.midi_input  = renoise.Midi.create_input_device(device_name [,callback] [, sysex_callback])
    --
    -- magic callback function
    local function main_callback(msg)
        for i, callback in ipairs(self.handler) do
            local result = callback[1](msg)
            if result[1] then
                table.remove(result,1)
                callback[2](self, result)
            end
        end
    end
    self.midi_input  = renoise.Midi.create_input_device(midi_device_name, main_callback)
end

-- register a callback handler
-- ---------------------------
--
-- test function must return a table where the first parameter is 
-- true  : call handle
-- false : don't call handle
--
-- the rest of the table will be the second argument of handle.
-- the first argument given to the handle will be the Launchpad object itself. 
--
function Launchpad:_register(test,handle)
    table.insert(self.handler,{ test, handle })
end

function Launchpad:_unregister_all()
    self.handler = {}
end

-- ------------------------------------------------------------
--                                          receiving (midi in)

-- callback convention always return an array first slot is true 
no = { false }

function is_top(msg)
    if msg[1] == 0xB0 then
        local x = msg[2] - 0x68 
        if (x > -1 and x < 8) then
            return { true,  x, msg[3] }
        end
    end
    return no
end

function is_right(msg)
    if msg[1] == 0x90 then
        local note = msg[2]
        if (bit.band(0x08,note) == 0x08) then
            local x = bit.rshift(note,4)
            if (x > -1 and x < 8) then 
                return { true,  x, msg[3] }
            end
        end
    end
    return no 
end

function is_matrix(msg)
    if msg[1] == 0x90 then
        local note = msg[2]
        if (bit.band(0x08,note) == 0) then
            local y = bit.rshift(note,4)
            local x = bit.band(0x07,note)
            if ( x > -1 and x < 8 and y > -1  and y < 8 ) then 
                return { true , x , y , msg[3] }
            end
        end
    end
    return no
end

function is_true(msg)
    return { true, msg }
end

function echo_top(pad,msg)
    local x   = msg[1]
    local vel = msg[2]
    print(("top    : (%X) = %X"):format(x,vel))
end
function echo_right(pad,msg)
    local x   = msg[1]
    local vel = msg[2]
    print(("right  : (%X) = %X"):format(x,vel))
end
function echo_matrix(pad,msg)
    local x   = msg[1]
    local y   = msg[2]
    local vel = msg[3]
    print(("matrix : (%X,%X) = %X"):format(x,y,vel))
end

function echo(pad, msg)
    local message = msg[1]
    print(("echo : got MIDI %X %X %X"):format(message[1], message[2], message[3]))
end

-- ------------------------------------------------------------
--                                           sending (midi out)

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
--                                            example functions

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

    -- callbacks
    pad:_unregister_all() 
    -- pad:_register(is_true, echo)
    pad:_register(is_matrix, echo_matrix)
    pad:_register(is_top,    echo_top)
    pad:_register(is_right,  echo_right)
end

function example(pad)
    example_colors(pad)
end


