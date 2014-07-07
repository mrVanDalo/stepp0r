--
-- User: palo
-- Date: 7/6/14
--

require 'Data/Note'
require 'Data/Color'
require 'Module/LaunchpadModule'
require 'Experimental/Observable'

-- ------------------------------------------------------------
-- Stepper Module
--
-- stepp the pattern
class "Stepper" (LaunchpadModule)

function Stepper:wire_launchpad(pad)
    self.pad = pad
end

function Stepper:__init()
    self.track      = 1
    self.instrument = 1
    self.note       = note.c
    self.octave     = 4

    self.observer   = Observer()
end

-- change notes in selection
-- (all "C-4"s to "E-4" in the selection in the current pattern)
--function example_function ()
--    local pattern_iter  = renoise.song().pattern_iterator
--    local pattern_index =  renoise.song().selected_pattern_index
--
--    for _,line in pattern_iter:lines_in_pattern(pattern_index) do
--        for _,note_column in pairs(line.note_columns) do
--            if (note_column.is_selected and
--                    note_column.note_string == "C-4") then
--                note_column.note_string = "E-4"
--            end
--        end
--    end
--end

function Stepper:_activate()
    self.observer:add_notifier(function(value)
        self:set_matrix(value)
    end,
    "renoise.song().transport.playback_pos.line")
end

-- ------------------------------------------------------------
-- set the stepper to the line
--
function Stepper:set_matrix(line)
    local x = ((line - 1) % 8) + 1
    local y = math.floor((line - 1) / 8) + 1
--    print(("x = %s , y = %s"):format(x,y))
    if (x < 9 and y < 5) then
        if (x == 1 and y == 1) then
            self.pad:set_matrix(8,4,color.off)
        elseif (x == 1) then
            self.pad:set_matrix(8, y - 1, color.off)
        else
            self.pad:set_matrix(x - 1 , y , color.off)
        end
        self.pad:set_matrix(x,y,color.green)
    end
end

function Stepper:_deactivate() end


