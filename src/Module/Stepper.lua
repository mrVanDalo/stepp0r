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

--- magic numbers
StepperData = {
    note = {
        off   = 120,
        empty = 121,
    },
    instrument = {
        empty = 255
    }
}

---
------------------------------------------------------------------ init
---

function Stepper:__init()
    self.track       = 1
    self.instrument  = 1
    self.note        = note.c
    self.octave      = 4
    -- ---
    -- navigation
    -- ---
    -- zoom
    self.zoom         = 1 -- influences grid size
    self.zoom_out_idx = 7
    self.zoom_in_idx  = 6
    -- pagination
    self.page         = 1 -- page of actual pattern
    self.page_inc_idx = 2
    self.page_dec_idx = 1
    self.page_start   = 0  -- line left before first pixel
    self.page_end     = 33 -- line right after last pixel
    -- rest
    self.sub_column   = 1 -- the column in the track
    self.pattern_idx  = 1 -- actual pattern
    -- rendering
    self.matrix      = {}
    self.color       = {
        off    = color.red,
        note   = color.yellow,
        empty  = color.off,
        active = color.yellow
    }
    self.playback_position_observer = PlaybackPositionObserver()
end



---
------------------------------------------------------------------ dependencys
---

function Stepper:wire_launchpad(pad)
    self.pad = pad
end

function Stepper:callback_set_instrument()
    return function (index,_)
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

---
------------------------------------------------------------------ library
---

--- calculate point (for matrix) of line
--
-- nil for is not on the matrix
--
-- todo : wirte tests for me and optemize me
--
function Stepper:line_to_point(line)
    -- page
    local l = line - self.page_start
    if l < 1 then return end
    -- zoom
    local li = l
    if (self.zoom > 1) then
        if ((l - 1) % self.zoom) ~= 0 then return end
        li = ((l - 1) / self.zoom) + 1
    end
    -- transformation
    local x = ((li - 1) % 8) + 1
    local y = math.floor((li - 1) / 8) + 1
    return {x,y}
end

--- calculate the line a point given by the actual matrix configuration
--
-- point_to_line(line_to_point(l)) == l should allways be true ?
--
-- todo : wirte tests for me and optemize me
function Stepper:point_to_line(x,y)
    return ((x + (8 * (y - 1))) - 1) * self.zoom + 1 + self.page_start
end

function Stepper:refresh_matrix()
    self:matrix_clear()
    self:matrix_update()
    -- self:pad_matrix_clear()
    self:pad_matrix_update()
end

--- get the active pattern object
--
-- self.pattern_idx will be kept up to date by an observable notifier
--
function Stepper:active_pattern()
    return renoise.song().patterns[self.pattern_idx]
end




---
------------------------------------------------------------------ boot
---

function Stepper:_activate()
    self:refresh_matrix()

    --- selected pattern changes
    --
    self.pattern_callback = function (_)
        self.pattern_idx = renoise.song().selected_pattern_index
        self:refresh_matrix()
    end
    renoise.song().selected_pattern_index_observable:add_notifier(self.pattern_callback)

    --- selected playback position
    --
    -- the green light that runs
    --
    self.playback_observer = function (line) self:callback_playback_position(line) end
    self.playback_position_observer:register(self.playback_observer)

    --- pad matrix listener
    --
    -- listens on click events on the launchpad matrix
    -- todo write this function inline and extract the sub routines
    self.pad:register_matrix_listener(function (_,msg)
        self:matrix_listener(msg)
    end)

    --- zoom knobs listener
    --
    -- listens on click events to manipulate the zoom
    --
    self:zoom_update_knobs()
    self.pad:register_top_listener(function (_,msg)
        if (msg.vel == 0 ) then return end
        if (msg.x == self.zoom_in_idx ) then
            self:zoom_in()
        elseif (msg.x == self.zoom_out_idx) then
            self:zoom_out()
        end
    end)

    --- pageination knobs listener
    --
    -- listens on click events to manipulate the pagination
    --
    self:page_update_knobs()
    self.pad:register_top_listener(function (_,msg)
        if (msg.vel == 0) then return end
        if(msg.x == self.page_inc_idx) then
            self:page_inc()
        elseif(msg.x == self.page_dec_idx)then
            self:page_dec()
        end
    end)
end

--- tear down
--
function Stepper:_deactivate()
    self.playback_position_observer:unregister(f)
end

---
------------------------------------------------------------------ pagination
---

function Stepper:page_update_knobs()
    if (self.page_start <= 0)  then
        self.pad:set_top(self.page_dec_idx,self.color.empty)
    else
        self.pad:set_top(self.page_dec_idx,self.color.active)
    end
    local pattern = self:active_pattern()
    if (self.page_end >= pattern.number_of_lines)  then
        self.pad:set_top(self.page_inc_idx,self.color.empty)
    else
        self.pad:set_top(self.page_inc_idx,self.color.active)
    end
end

function Stepper:page_inc()
    local pattern = self:active_pattern()
    if (self.page_end >= pattern.number_of_lines) then return end
    self.page = self.page + 1
    self:page_update_borders()
    self:page_update_knobs()
    self:refresh_matrix()
end

function Stepper:page_dec()
    if(self.page_start <= 0 ) then return end
    self.page = self.page - 1
    self:page_update_borders()
    self:page_update_knobs()
    self:refresh_matrix()
end

function Stepper:page_update_borders()
    self.page_start = ((self.page - 1) * 32 * self.zoom)
    self.page_end   = self.page_start + 1 + 32 * self.zoom
    print("update page borders", self.page, self.page_start, self.page_end)
end






----
------------------------------------------------------------------ zoom
---

function Stepper:zoom_out()
    local pattern = self:active_pattern()
    if (self.zoom < pattern.number_of_lines / 32) then
        -- update zoom
        self.zoom = self.zoom * 2
        -- update page
        self.page = (self.page * 2 ) - 1
        self:page_update_borders()
        -- correction
        if (self.page_start >= pattern.number_of_lines) then
            self.page = self.page - 2
            self:page_update_borders()
        end
        -- refresh page
        self:refresh_matrix()
    end
    self:page_update_knobs()
    self:zoom_update_knobs()
end

function Stepper:zoom_in()
    if (self.zoom > 1) then
        -- update zoom
        self.zoom = self.zoom / 2
        -- update page
        if (self.page > 1) then
            self.page = math.floor(self.page / 2)
        end
        self:page_update_borders()
        -- refresh martix
        self:refresh_matrix()
    end
    self:page_update_knobs()
    self:zoom_update_knobs()
end

function Stepper:zoom_update_knobs()
    if (self.zoom > 1) then
        self.pad:set_top(self.zoom_in_idx,self.color.active)
    else
        self.pad:set_top(self.zoom_in_idx,self.color.empty)
    end
    local pattern = self:active_pattern()
    if (self.zoom < (pattern.number_of_lines / 32)) then
        self.pad:set_top(self.zoom_out_idx,self.color.active)
    else
        self.pad:set_top(self.zoom_out_idx,self.color.empty)
    end
end

---
------------------------------------------------------------------ stepper
---

--- listens to events from the user on the matrix
--
function Stepper:matrix_listener(msg)
    if (msg.vel == 0) then return end
    if (msg.y > 4 )   then return end
    local column           = self:calculate_track_position(msg.x,msg.y)
    if column then
        if column.note_value == StepperData.note.empty then
            column.note_value         = pitch(self.note,self.octave)
            column.instrument_value   = (self.instrument - 1)
            self.matrix[msg.x][msg.y] = self.color.note
            if column.note_value == 120 then
                self.pad:set_matrix(msg.x,msg.y,self.color.off)
            else
                self.pad:set_matrix(msg.x,msg.y,self.color.note)
            end
        else
            column.note_value         = StepperData.note.empty
            column.instrument_value   = StepperData.instrument.empty
            self.matrix[msg.x][msg.y] = self.color.empty
            self.pad:set_matrix(msg.x,msg.y,self.color.empty)
        end
    end
end

--- should ensure the column exist
--
-- todo might be deprecated, because this should be done by the choosser
--
function Stepper:ensure_sub_column_exist()
   -- todo write me
end

--- calculates the position in track
--
-- the point should come from the launchpad.
-- the note_column that is selected will be taken in account
--
-- @return nil if nothing found
--
function Stepper:calculate_track_position(x,y)
    local line       = self:point_to_line(x,y)
    local pattern    = self:active_pattern()
    local found_line = pattern.tracks[self.track].lines[line]
    if found_line then
        self:ensure_sub_column_exist()
        return found_line.note_columns[self.sub_column]
    else
        return nil
    end
end

--- update pad by the given matrix
--
function Stepper:matrix_update_pad(x,y)
    if(self.matrix[x][y]) then
        self.pad:set_matrix(x,y,self.matrix[x][y])
    else
        self.pad:set_matrix(x,y,color.off)
    end
end

--- update memory-matrix by the current selected pattern
function Stepper:matrix_update()
    local pattern_iter  = renoise.song().pattern_iterator
    for pos,line in pattern_iter:lines_in_pattern_track(self.pattern_idx, self.track) do
        if not table.is_empty(line.note_columns) then
            local note_column = line:note_column(self.sub_column)
            if(note_column.note_value ~= StepperData.note.empty) then
                local xy = self:line_to_point(pos.line)
                if xy then
                    local x = xy[1]
                    local y = xy[2]
                    if (y < 5 and y > 0) then
                        if (note_column.note_value == StepperData.note.off) then
                            self.matrix[x][y] = self.color.off
                        else
                            self.matrix[x][y] = self.color.note
                        end
                    end
                end
            end
        end
    end
end

function Stepper:matrix_clear()
    self.matrix = {}
    for x = 1, 8 do self.matrix[x] = {} end
end

function Stepper:pad_matrix_clear()
    for y = 1, 4 do
        for x = 1,8 do
            self.pad:set_matrix(x,y,color.off)
        end
    end
end

function Stepper:pad_matrix_update()
    for x = 1, 8 do
        for y = 1, 4 do
            self:matrix_update_pad(x,y)
        end
    end
end

-- ------------------------------------------------------------
-- set the stepper to the line
--
function Stepper:callback_playback_position(pos)
    if self.pattern_idx ~= pos.sequence then return end
    local line = pos.line
    if (line <= self.page_start) then return end
    if (line >= self.page_end)   then return end
    local xy = self:line_to_point(line)
    if not xy then return end
    local x = xy[1]
    local y = xy[2]
    if (x < 9 and y < 5) then
        if (x == 1 and y == 1) then
            self:matrix_update_pad(8,4)
        elseif (x == 1) then
            self:matrix_update_pad(8,y-1)
        else
            self:matrix_update_pad(x-1,y)
        end
        self.pad:set_matrix(x,y,color.green)
    end
end


