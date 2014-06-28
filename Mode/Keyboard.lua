
require 'LaunchpadMode'

-- --
-- Keyboard Mode 
--
class "Keyboard" (LaunchpadMode)

function Keyboard:__init(pad)
    LaunchpadMode:__init(self)
    self.pad    = pad
    self.offset = 6
    self.notes  = { 
        c = {0,1}, cis = {1,0},
        d = {1,1}, es  = {2,0},
        e = {2,1}, 
        f = {3,1}, fis = {4,0},
        g = {4,1}, as  = {5,0},
        a = {5,1}, b   = {6,0},
        h = {6,1},
        C = {7,1},
    }
    -- default
    self.oct  = 4
    self.note = self.notes.c
end

function Keyboard:_activate()
    self.pad:clear()
    self.pad:set_flash(true)
    self:_setup_keys()
    self:_setup_callbacks()
end

function Keyboard:_deactivate()
    self.pad:unregister_matrix_listener()
end

function Keyboard:_setup_callbacks()
    local function matrix_callback(pad,msg)
        local press   = 0x7F
        local release = 0x00
        if (msg.y >= self.offset and msg.vel ~= release) then
            if (msg.y == 7) then
                -- notes only
                self:set_note(msg.x, msg.y)
            else
                if (msg.x == 0) then
                    self:octave_down()
                elseif (msg.x == 7) then
                    self:octave_up()
                else
                    self:set_note(msg.x, msg.y)
                end
            end
            self:update_keys()
        end
    end
    self.pad:register_matrix_listener(matrix_callback)
end

function Keyboard:octave_down()
    if (self.oct > 1) then
        self.oct = self.oct - 1
    end
end
function Keyboard:octave_up()
    if (self.oct < 8) then
        self.oct = self.oct + 1
    end
end
function Keyboard:set_note(x,y)
    print(("set (%s,%s)"):format(x,y))
end
function Keyboard:update_keys()
    self:update_notes()
    self:update_active_note()
    self:update_octave()
end

function Keyboard:_setup_keys()
    self:update_keys()
    -- manover buttons
    self.pad:set_matrix(
        0,
        self.offset,
        self.pad.color.orange)
    self.pad:set_matrix(
        7,
        self.offset,
        self.pad.color.orange)
    -- off button
    self.pad:set_matrix(
        3,
        self.offset,
        self.pad.color.red)
end

function Keyboard:update_octave()
    self.pad:set_matrix(
        self.oct - 1, 
        1 + self.offset,
        self.pad.color.yellow)
end

function Keyboard:update_notes()
    for note,slot in pairs(self.notes) do
        self.pad:set_matrix(
            slot[1],
            slot[2] + self.offset,
            self.pad.color.dim.green)
    end
end

function Keyboard:update_active_note()
    local x     = self.note[1]
    local y     = self.note[2] + self.offset
    local color = self.pad.color.orange
    local off   = self.pad.color.off
    -- self.pad:set_matrix(x,y,off)
    print(("active note : (%s,%s)"):format(x,y))
    self.pad:set_matrix( x, y, color )
        
end

