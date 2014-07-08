--
-- User: palo
-- Date: 7/6/14
--

require 'Data/Note'
require 'Data/Color'
require 'Module/LaunchpadModule'
require 'Experimental/PlaybackPositionObserver'

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

    self.playback_position_observer = PlaybackPositionObserver()
end

function Stepper:callback_set_instrument()
    return function (index)
        self.track      = index
        self.instrument = index
        self:clear_matrix()
        self:update_matrix()
    end
end

function Stepper:clear_matrix()
    for y = 1, 4 do
        for x = 1,8 do
            self.pad:set_matrix(x,y,color.off)
        end
    end
end

function Stepper:update_matrix()
    local pattern_iter = renoise.song().pattern_iterator
    local pattern_index = renoise.song().selected_pattern_index
    for pos,line in pattern_iter:lines_in_pattern_track(pattern_index, self.track) do
        if not table.is_empty(line.note_columns) then

            local note_column = line:note_column(1)
            -- note_column:clear()
            -- local arp_index = math.mod(pos.line - 1, #arp_sequence) + 1
            -- note_column.note_string = arp_sequence[arp_index].note
            -- note_column.instrument_value = arp_sequence[arp_index].instrument
            -- note_column.volume_value = arp_sequence[arp_index].volume
            print(pos, note_column.note_string)
        end
    end
end


function Stepper:_activate()
    self.f = function (line) self:callback_playback_position(line) end
    self.playback_position_observer:register(self.f)
end

-- ------------------------------------------------------------
-- set the stepper to the line
--
function Stepper:callback_playback_position(line)
    local x = ((line - 1) % 8) + 1
    local y = math.floor((line - 1) / 8) + 1
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

function Stepper:_deactivate()
    self.playback_position_observer:unregister(f)
end


