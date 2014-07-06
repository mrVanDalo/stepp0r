--
-- User: palo
-- Date: 7/4/14
--

require 'Data/Color'

-- A class to choose the Instruments
class "Chooser" (LaunchpadModule)

-- register callback that gets a `index of instrument`
function Chooser:register_select_instrument(callback)
    table.insert(self.callback_select_instrument, callback)
end

function Chooser:wire_launchpad(pad)
    self.pad = pad
end

function Chooser:__init()
    LaunchpadModule:__init(self)
    self.active      = 1  -- active instrument index
    self.row         = 6
    self.inst_offset = 0  -- which is the first instrument
    self.color = {
        active  = color.flash.green,
        passive = color.green,
    }
    -- callbacks
    self.callback_select_instrument = {}
end

function Chooser:_activate()
    self:update_row()
    self:matrix_callback()
    self:top_callback()
end

function Chooser:select_instrument(x)
    self.active = self.inst_offset + x
    local found = renoise.song().instruments[self.active]
    if not found        then return  end
    if found.name == "" then return  end
    print("found ", found.name)
    -- callback
    for _, callback in ipairs(self.callback_select_instrument) do
        callback(self.active)
    end
end

function Chooser:matrix_callback()
    local function matrix_listener(_,msg)
        if msg.vel == 0x00     then return end
        if (msg.y ~= self.row) then return end
        self:select_instrument(msg.x)
        self:update_row()
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
            print(nr, instrument.name)
            if nr == self.active then
                self.pad:set_matrix(nr - self.inst_offset, self.row, self.color.active)
            else
                self.pad:set_matrix(nr - self.inst_offset, self.row, self.color.passive)
            end
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
