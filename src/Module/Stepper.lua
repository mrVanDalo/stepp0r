--
-- User: palo
-- Date: 7/6/14
--

require 'Data/Note'
require 'Data/Velocity'
require 'Data/Color'
require 'Module/Module'
require 'Experimental/PlaybackPositionObserver'


--- ======================================================================================================
---
---                                                 [ Stepper Module ]
---
--- stepp the pattern

class "Stepper" (Module)

StepperData = {
    note = {
        off   = 120,
        empty = 121,
    },
    instrument = { empty = 255 },
    delay      = { empty = 0 },
    volume     = { empty = 255 },
    panning    = { empty = 255 },
    color = {
        clear = Color.off
    }
}

--- ======================================================================================================
---
---                                                 [ INIT ]

function Stepper:__init()
    Module:__init(self)
    self.track       = 1
    self.instrument  = 1
    self.note        = Note.note.c
    self.octave      = 4
    self.delay       = 0
    self.volume      = StepperData.instrument.empty
    self.pan         = StepperData.instrument.empty
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
    self.track_column = 1 -- the column in the track
    self.pattern_idx  = 1 -- actual pattern
    -- rendering
    self.matrix      = {}
    self.color       = {
        stepper = Color.green,
        page = {
            active   = Color.yellow,
            inactive = Color.off,
        },
        zoom = {
            active   = Color.yellow,
            inactive = Color.off,
        },
        note = {
            off   = Color.red,
            on    = Color.yellow,
            empty = Color.off,
        },
    }
    self.playback_position_observer = PlaybackPositionObserver()
end

function Stepper:wire_launchpad(pad)
    self.pad = pad
end

function Stepper:callback_set_instrument()
    return function (index,column)
        if self.is_not_active then return end
        self.track        = index
        self.track_column = column
        self.instrument   = index
        self:refresh_matrix()
    end
end

function Stepper:callback_set_note()
    return function (note,octave)
        if self.is_not_active then return end
        self.note   = note
        self.octave = octave
    end
end

function Stepper:callback_set_delay()
    return function (delay)
        if self.is_not_active then return end
        self.delay = delay
    end
end
function Stepper:callback_set_volume()
    return function (volume)
        if self.is_not_active then return end
        self.volume = volume
    end
end
function Stepper:callback_set_pan()
    return function (pan)
        if self.is_not_active then return end
        self.pan = pan
    end
end












--- ======================================================================================================
---
---                                                 [ BooT ]

function Stepper:_activate()

    --- selected pattern changes
    --
    self.pattern_idx = renoise.song().selected_pattern_index
    if self.is_first_run then
        renoise.song().selected_pattern_index_observable:add_notifier(function (_)
            if self.is_not_active then return end
            self.pattern_idx = renoise.song().selected_pattern_index
            self:refresh_matrix()
        end)
    end

    --- selected playback position
    --
    -- the green light that runs
    --
    -- todo : maybe this should also be inlined here
    if self.is_first_run then
        self.playback_position_observer:register(function (line)
            if self.is_not_active then return end
            self:callback_playback_position(line)
        end)
    end

    --- pad matrix listener
    --
    -- listens on click events on the launchpad matrix
    if self.is_first_run then
        self.pad:register_matrix_listener(function (_,msg)
            if self.is_not_active          then return end
            if msg.vel == Velocity.release then return end
            if msg.y > 4                   then return end
            local column           = self:calculate_track_position(msg.x,msg.y)
            if not column then return end
            if column.note_value == StepperData.note.empty then
                column.note_value         = pitch(self.note,self.octave)
                column.instrument_value   = (self.instrument - 1)
                column.delay_value        = self.delay
                column.panning_value      = self.pan
                column.volume_value       = self.volume
                if column.note_value == StepperData.note.off then
                    self.matrix[msg.x][msg.y] = self.color.note.off
                else
                    self.matrix[msg.x][msg.y] = self.color.note.on
                end
            else
                column.note_value         = StepperData.note.empty
                column.instrument_value   = StepperData.instrument.empty
                column.delay_value        = StepperData.delay.empty
                column.panning_value      = StepperData.panning.empty
                column.volume_value       = StepperData.volume.empty
                self.matrix[msg.x][msg.y] = self.color.note.empty
            end
            self.pad:set_matrix(msg.x,msg.y,self.matrix[msg.x][msg.y])
        end)
    end

    --- zoom knobs listener
    --
    -- listens on click events to manipulate the zoom
    --
    self:zoom_update_knobs()
    if self.is_first_run then
        self.pad:register_top_listener(function (_,msg)
            if self.is_not_active            then return end
            if msg.vel == Velocity.release   then return end
            if (msg.x == self.zoom_in_idx ) then
                self:zoom_in()
            elseif msg.x == self.zoom_out_idx then
                self:zoom_out()
            end
        end)
    end

    --- pageination knobs listener
    --
    -- listens on click events to manipulate the pagination
    --
    self:page_update_knobs()
    if self.is_first_run then
        self.pad:register_top_listener(function (_,msg)
            if self.is_not_active            then return end
            if msg.vel == Velocity.release   then return end
            if msg.x == self.page_inc_idx then
                self:page_inc()
            elseif msg.x == self.page_dec_idx then
                self:page_dec()
            end
        end)
    end

    --- refresh the matrix
    self:refresh_matrix()
end

--- tear down
--
function Stepper:_deactivate()
    -- todo unregister playback position here
    self:page_clear_knobs()
    self:zoom_clear_knobs()
    self:matrix_clear()
    self:pad_matrix_update()
end










--- ======================================================================================================
---
---                                                 [ Pagination ]

function Stepper:page_update_knobs()
    if (self.page_start <= 0)  then
        self.pad:set_top(self.page_dec_idx,self.color.page.inactive)
    else
        self.pad:set_top(self.page_dec_idx,self.color.page.active)
    end
    local pattern = self:active_pattern()
    if (self.page_end >= pattern.number_of_lines)  then
        self.pad:set_top(self.page_inc_idx,self.color.page.inactive)
    else
        self.pad:set_top(self.page_inc_idx,self.color.page.active)
    end
end

function Stepper:page_clear_knobs()
    self.pad:set_top(self.page_dec_idx,Color.off)
    self.pad:set_top(self.page_inc_idx,Color.off)
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
    -- print("update page borders", self.page, self.page_start, self.page_end)
end






--- ======================================================================================================
---
---                                                 [ ZOOM ]

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
        self.pad:set_top(self.zoom_in_idx,self.color.zoom.active)
    else
        self.pad:set_top(self.zoom_in_idx,self.color.zoom.inactive)
    end
    local pattern = self:active_pattern()
    if (self.zoom < (pattern.number_of_lines / 32)) then
        self.pad:set_top(self.zoom_out_idx,self.color.zoom.active)
    else
        self.pad:set_top(self.zoom_out_idx,self.color.zoom.inactive)
    end
end

function Stepper:zoom_clear_knobs()
    self.pad:set_top(self.zoom_in_idx,Color.off)
    self.pad:set_top(self.zoom_out_idx,Color.off)
end

--- ======================================================================================================
---
---                                                 [ Library ]

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
        return found_line.note_columns[self.track_column]
    else
        return nil
    end
end



--- ======================================================================================================
---
---                                                 [ Rendering ]


--- update pad by the given matrix
--
function Stepper:matrix_update_pad(x,y)
    if(self.matrix[x][y]) then
        self.pad:set_matrix(x,y,self.matrix[x][y])
    else
        self.pad:set_matrix(x,y,StepperData.color.clear)
    end
end

--- update memory-matrix by the current selected pattern
--
function Stepper:matrix_update()
    local pattern_iter  = renoise.song().pattern_iterator
    for pos,line in pattern_iter:lines_in_pattern_track(self.pattern_idx, self.track) do
        if not table.is_empty(line.note_columns) then
            -- print("note_column")
            -- print(self.track_column)
            local note_column = line:note_column(self.track_column)
            if(note_column.note_value ~= StepperData.note.empty) then
                local xy = self:line_to_point(pos.line)
                if xy then
                    local x = xy[1]
                    local y = xy[2]
                    if (y < 5 and y > 0) then
                        if (note_column.note_value == StepperData.note.off) then
                            self.matrix[x][y] = self.color.note.off
                        else
                            self.matrix[x][y] = self.color.note.on
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
            self.pad:set_matrix(x,y,StepperData.color.clear)
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

--- updates the point that should blink on the launchpad
--
-- will be hooked in by the playback_position observable
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
        self.pad:set_matrix(x,y,self.color.stepper)
    end
end


