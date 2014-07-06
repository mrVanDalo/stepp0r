--
-- User: palo
-- Date: 7/6/14
--

require 'Data/Note'
require 'Data/Color'
require 'Module/LaunchpadModule'

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
    self.note       = notes.c
    self.octave     = 4
end

-- change notes in selection
-- (all "C-4"s to "E-4" in the selection in the current pattern)
function example_function ()
    local pattern_iter  = renoise.song().pattern_iterator
    local pattern_index =  renoise.song().selected_pattern_index

    for _,line in pattern_iter:lines_in_pattern(pattern_index) do
        for _,note_column in pairs(line.note_columns) do
            if (note_column.is_selected and
                    note_column.note_string == "C-4") then
                note_column.note_string = "E-4"
            end
        end
    end
end

function Stepper:_activate()
end

function Stepper:_deactivate() end


