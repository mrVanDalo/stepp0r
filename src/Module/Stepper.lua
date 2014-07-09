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
    self.track       = 1
    self.instrument  = 1
    self.note        = note.c
    self.octave      = 4
    -- navigation
    self.sub_column  = 1 -- the column in the track
    self.zoom_factor = 1 -- influences grid size
    self.pattern     = 1 -- actual pattern
    self.page        = 1 -- page of actual pattern
    self.page_start  = 1  -- line of first pixel
    self.page_end    = 32 -- line of last pixel
    -- rendering
    self.matrix      = {}
    self.color       = {
        off  = color.red,
        note = color.yellow,
        empty = color.off
    }

    self.playback_position_observer = PlaybackPositionObserver()
end

function Stepper:callback_set_instrument()
    return function (index)
        self.track      = index
        self.instrument = index
        self:refresh_matrix()
    end
end


function Stepper:callback_set_note()
    return function (note,octave)
        self.note   = note
        self.octave = octave
    end
end

function line_to_point(line)
    local x = ((line - 1) % 8) + 1
    local y = math.floor((line - 1) / 8) + 1
    return {x,y}
end




function Stepper:refresh_matrix()
    self:clear_matrix()
    self:update_matrix()
    -- self:clear_pad_matrix()
    self:update_pad_matrix()
end

function Stepper:_activate()
    self:refresh_matrix()

    -- register pattern_index callback
    self.pattern_callback = function (_)
        self:refresh_matrix()
    end
    renoise.song().selected_pattern_index_observable:add_notifier(self.pattern_callback)

    -- register play_position callback
    self.f = function (line) self:callback_playback_position(line) end
    self.playback_position_observer:register(self.f)

    -- register pad matrix listener
    self.pad:register_matrix_listener(function (_,msg)
        if (msg.vel == 0) then return end
        if (msg.y > 4 )   then return end
        local column           = self:calculate_column(msg.x,msg.y)
        local empty_note       = 121
        local off_note         = 120
        local empty_instrument = 255
        if column.note_value == empty_note then
            column.note_value         = pitch(self.note,self.octave)
            column.instrument_value   = (self.instrument - 1)
            self.matrix[msg.x][msg.y] = self.color.note
            self.pad:set_matrix(msg.x,msg.y,self.color.note)
        else
            column.note_value         = empty_note
            column.instrument_value   = empty_instrument
            self.matrix[msg.x][msg.y] = self.color.empty
            self.pad:set_matrix(msg.x,msg.y,self.color.empty)
        end
    end)
end

function Stepper:ensure_sub_column_exist()
   -- todo write me
end

function Stepper:calculate_column(x,y)
    local line = x + (8 * (y - 1))
    self:ensure_sub_column_exist()
    local pattern_index = renoise.song().selected_pattern_index
    return renoise.song().patterns[pattern_index].tracks[self.track].lines[line].note_columns[self.sub_column]
end

function Stepper:update_pad_with_matrix(x,y)
    if(self.matrix[x][y]) then
        self.pad:set_matrix(x,y,self.matrix[x][y])
    else
        self.pad:set_matrix(x,y,color.off)
    end
end

function Stepper:update_matrix()
    local pattern_iter  = renoise.song().pattern_iterator
    local pattern_index = renoise.song().selected_pattern_index
    for pos,line in pattern_iter:lines_in_pattern_track(pattern_index, self.track) do
        if not table.is_empty(line.note_columns) then
            local note_column = line:note_column(self.sub_column)
            if(note_column.note_string ~= "---") then
                local xy = line_to_point(pos.line)
                local x = xy[1]
                local y = xy[2]
                if (y < 5) then
                    if (note_column.note_string == "OFF") then
                        self.matrix[x][y] = self.color.off
                    else
                        self.matrix[x][y] = self.color.note
                    end
                end
            end
        end
    end
end

function Stepper:clear_pad_matrix()
    for y = 1, 4 do
        for x = 1,8 do
            self.pad:set_matrix(x,y,color.off)
        end
    end
end

function Stepper:clear_matrix()
    self.matrix = {}
    for x = 1, 8 do self.matrix[x] = {} end
end

function Stepper:update_pad_matrix()
    for x = 1, 8 do
        for y = 1, 4 do
            self:update_pad_with_matrix(x,y)
        end
    end
end

-- ------------------------------------------------------------
-- set the stepper to the line
--
function Stepper:callback_playback_position(line)
    local xy = line_to_point(line)
    local x = xy[1]
    local y = xy[2]
    if (x < 9 and y < 5) then
        if (x == 1 and y == 1) then
            self:update_pad_with_matrix(8,4)
        elseif (x == 1) then
            self:update_pad_with_matrix(8,y-1)
        else
            self:update_pad_with_matrix(x-1,y)
        end
        self.pad:set_matrix(x,y,color.green)
    end
end

function Stepper:_deactivate()
    self.playback_position_observer:unregister(f)
end

