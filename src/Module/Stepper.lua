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
        self:clear_line(value)
        self:set_matrix(value)
    end,
    "renoise.song().transport.playback_pos.line")
end

function Stepper:clear_line(line)
    local l_line = line / 8
    if l_line < 4 then
        for i = 1, 8, 1 do
            self.pad:set_matrix(l_line,i,color.off)
        end
    end
end

function Stepper:set_matrix(line)
    local x = line % 8
    local y = (line / 8) + 1
    self.pad:set_matrix(x,y,color.green)
end

function Stepper:_deactivate() end


