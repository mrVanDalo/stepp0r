--
-- User: palo
-- Date: 7/4/14
--

-- A class to choose the Instruments
class "Chooser" (LaunchpadModule)

function Chooser:__init(pad)
    LaunchpadModule:__init(self)
    self.pad         = pad
    self.row         = 6
    self.inst_offset = 0  -- which is the first instrument
    self.active      = {
        index      = -1 ,
        pad_index  = -1 ,
        instrument = nil,
    }
end

function Chooser:_activate()
    self:update_row()
    self:matrix_callback()
    self:top_callback()
end

function Chooser:matrix_callback()
    local function matrix_listener(_,msg)
        if msg.vel == 0x00 then return end
        if (msg.y ~= self.row) then return end
        local found = renoise.song().instruments[ self.inst_offset + msg.x ]
        if found and found.name ~= "" then
            print("found ", found.name)
        end
    end
    self.pad:register_matrix_listener(matrix_listener)
end

function Chooser:top_callback() end

function Chooser:update_row()
    self:clear_row()
    for nr, instrument in ipairs(renoise.song().instruments) do
        if nr - self.inst_offset > 8 then
            break
        end
        if instrument.name ~= "" then
            self.pad:set_matrix(nr - self.inst_offset, self.row, self.pad.color.green)
            print(nr, instrument.name)
        end
    end
end

function Chooser:clear_row()
    for x = 1, 8, 1 do
        self.pad:set_matrix(x,self.row,self.pad.color.off)
    end
end

function Chooser:_deactivate()
    self:clear_row()
end
