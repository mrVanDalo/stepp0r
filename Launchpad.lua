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
    self:unregister_all()
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
            self:connect(v)
        end
    end
end

-- --
-- connect launchpad to a midi device
--
function Launchpad:connect(midi_device_name)
    print("connect : " ..  midi_device_name)
    self.midi_out    = renoise.Midi.create_output_device(midi_device_name)
    --
    -- magic callback function
    local function main_callback(msg)
        local result = _is_matrix(msg)
        if (result.flag) then
            for i, callback in ipairs(self._matrix_listener) do
                callback(self, result)
            end
            return
        end
        --
        result = _is_top(msg)
        if (result.flag) then
            for i, callback in ipairs(self._top_listener) do
                callback(self, result)
            end
            return
        end
        --
        result = _is_right(msg)
        if (result.flag) then
            for i, callback in ipairs(self._right_listener) do
                callback(self, result)
            end
            return
        end
    end
    self.midi_input  = renoise.Midi.create_input_device(midi_device_name, main_callback)
end

-- --
-- register a callback handler
--
local function Launchpad:_register(list,handle)
    table.insert(list,handle)
end


-- ------------------------------------------------------------
--                                          receiving (midi in)

-- callback convention always return an array first slot is true 
no = { flag = false }

-- --
-- Test functions for the handler
--
function _is_top(msg)
    if msg[1] == 0xB0 then
        local x = msg[2] - 0x68 
        if (x > -1 and x < 8) then
            return { flag = true,  x = x, vel = msg[3] }
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
                return { flag = true,  x = x, vel = msg[3] }
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
                return { flag = true , x = x , y = y , vel = msg[3] }
            end
        end
    end
    return no
end

-- --
-- register handler functions
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

-- -- 
-- unregister
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

-- --
-- example handler
--
function echo_top(pad,msg)
    local x   = msg.x
    local vel = msg.vel
    --print(top)
    print(("top    : (%X) = %X"):format(x,vel))
end
function echo_right(pad,msg)
    local x   = msg.x
    local vel = msg.vel
    --print(right)
    print(("right  : (%X) = %X"):format(x,vel))
end
function echo_matrix(pad,msg)
    local x   = msg.x
    local y   = msg.y
    local vel = msg.vel
    --print(matrix)
    print(("matrix : (%X,%X) = %X"):format(x,y,vel))
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
    pad:unregister_all()

    pad:register_matrix_listener(echo_matrix)
    pad:register_top_listener(echo_top)
    pad:register_right_listener(echo_right)
end

function example(pad)
    example_colors(pad)
end


