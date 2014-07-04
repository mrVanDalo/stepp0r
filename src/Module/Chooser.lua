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
end

function Chooser:_activate()
    -- show active instruments
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

function Chooser:_deactivate()
    -- clear my row
    for x = 1, 8, 1 do
        pad:set_matrix(x,self.row,pad.colors.off)
    end
end



