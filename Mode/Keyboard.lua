
require 'LaunchpadMode'

-- --
-- Keyboard Mode 
--
class "Keyboard" (LaunchpadMode)

function Keyboard:__init(pad)
    self.pad = pad
    LaunchpadMode:__init(self)
    self.notes = { 
        c = {1, 0}, cis = {0,0},
        d = {1,1},
        e = {1,2},
        f = {1,3},
        g = {1,4},
        a = {1,5},
        h = {1,6}
    }
    self.oct  = 4
    self.note = self.notes.c
end

function Keyboard:_activate()
    self.pad:set_flash()
    self.pad:clear()
    self:_setup_keys()
end

function Keyboard:_setup_keys()
    for note,slot in pairs(self.notes) do
        self.pad:set_matrix(slot[1],slot[2],self.pad.color.red)
    end
    self.pad:set_matrix(self.note[1],self.note[2],self.pad.color.green)
end

function Keyboard:_deactivate()
    print("du")
    -- pass
end
