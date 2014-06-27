
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
    self.pad:set_flash(true)
    self.pad:clear()
    self:_setup_keys()
end

function Keyboard:_setup_keys()
    -- keys
    for note,slot in pairs(self.notes) do
        self.pad:set_matrix(
            slot[1],
            slot[2] + self.offset,
            self.pad.color.dim.green)
    end
    -- active note
    self:set_active_note()
    -- octave
    self.pad:set_matrix(
        self.oct - 1, 
        1 + self.offset,
        self.pad.color.yellow)
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

function Keyboard:set_active_note()
    self.pad:set_matrix(
        self.note[1],
        self.note[2] + self.offset,
        self.pad.color.off)
    self.pad:set_matrix(
        self.note[1],
        self.note[2] + self.offset,
        self.pad.color.flash.green)
end

function Keyboard:_deactivate()
    print("du")
    -- pass
end
