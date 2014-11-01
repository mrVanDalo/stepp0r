--- ======================================================================================================
---
---                                                 [ Adjuster Module ]
---
--- Find Addjust

class "Adjuster" (Module)

AdjusterData = {
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

function Adjuster:__init()
    Module:__init(self)
    self.track_idx       = 1
    self.instrument_idx  = 1
    self.note        = Note.note.c
    self.octave      = 4
    self.delay       = 0
    self.volume      = AdjusterData.instrument.empty
    self.pan         = AdjusterData.instrument.empty
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
    self.track_column_idx = 1 -- the column in the track
    self.pattern_idx      = 1 -- actual pattern
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
            selected = {
                off   = Color.red,
                on    = Color.yellow,
                empty = Color.off,
            }
        },
    }
    self.playback_position_observer = nil
    self.playback_position_last_x = 1
    self.playback_position_last_y = 1


    -- create listeners
    self:__create_pad_listener()
    self:__create_zoom_listener()
    self:__create_page_listener()
    self:__create_select_pattern_listener()
end

function Adjuster:wire_launchpad(pad)
    self.pad = pad
end

function Adjuster:wire_playback_position_observer(playback_position_observer)
    if self.playback_position_observer then
        self:unregister_playback_position_observer()
    end
    self.playback_position_observer = playback_position_observer
end

function Adjuster:callback_set_instrument()
    return function (instrument_idx, track_idx, column_idx)
        if self.is_not_active then return end
        self.track_idx        = track_idx
        self.track_column_idx = column_idx
        self.instrument_idx   = instrument_idx
        self:refresh_matrix()
    end
end

function Adjuster:callback_set_note()
    return function (note,octave)
        if self.is_not_active then return end
        self.note   = note
        self.octave = octave
    end
end

function Adjuster:callback_set_delay()
    return function() end
    -- todo does nothing yet
--    return function (delay)
--        if self.is_not_active then return end
--        self.delay = delay
--    end
end
function Adjuster:callback_set_volume()
    return function() end
    -- todo does nothing yet
--    return function (volume)
--        if self.is_not_active then return end
--        self.volume = volume
--    end
end
function Adjuster:callback_set_pan()
    return function() end
    -- todo does nothing yet
--    return function (pan)
--        if self.is_not_active then return end
--        self.pan = pan
--    end
end

function Adjuster:__create_select_pattern_listener()
    self.__select_pattern_listener = function (_)
        if self.is_not_active then return end
        self.pattern_idx = renoise.song().selected_pattern_index
        self:refresh_matrix()
    end
end

--- zoom knobs listener
--
-- listens on click events to manipulate the zoom
--
function Adjuster:__create_zoom_listener()
    self.__zoom_listener = function (_,msg)
        if self.is_not_active            then return end
        if msg.vel == Velocity.release   then return end
        if (msg.x == self.zoom_in_idx ) then
            self:zoom_in()
        elseif msg.x == self.zoom_out_idx then
            self:zoom_out()
        end
    end
end

--- pageination knobs listener
--
-- listens on click events to manipulate the pagination
--
function Adjuster:__create_page_listener()
    self.__page_listener = function (_,msg)
        if self.is_not_active            then return end
        if msg.vel == Velocity.release   then return end
        if msg.x == self.page_inc_idx then
            self:page_inc()
        elseif msg.x == self.page_dec_idx then
            self:page_dec()
        end
    end
end

--- ======================================================================================================
---
---                                                 [ BooT ]

function Adjuster:_activate()
    -- playback position
    self:__register_playback_position_observer()
    -- selected pattern
    self.pattern_idx = renoise.song().selected_pattern_index
    add_notifier(renoise.song().selected_pattern_index_observable, self.__select_pattern_listener)
    -- zoom
    self:zoom_update_knobs()
    self.pad:register_top_listener(self.__zoom_listener)
    -- pagination
    self:page_update_knobs()
    self.pad:register_top_listener(self.__page_listener)
    -- main matrix
    self:refresh_matrix()
    self.pad:register_matrix_listener(self.__matrix_listener)
end

--- tear down
--
function Adjuster:_deactivate()
    -- clear connected layers
    self:page_clear_knobs()
    self:zoom_clear_knobs()
    self:__matrix_clear()
    self:__render_matrix()
    -- unregister notifiers/listeners
    self:unregister_playback_position_observer()
    remove_notifier(renoise.song().selected_pattern_index_observable, self.__select_pattern_listener)
    self:pad:unregister_top_listener(self.__zoom_listener)
    self.pad:unregister_top_listener(self.__page_listener)
    self:pad:unregister_matrix_listener(self.__matrix_listener)
end


--- pad matrix listener
--
-- listens on click events on the launchpad matrix
function Adjuster:__create_pad_listener()
    self.__matrix_listener = function (_,msg)
        if self.is_not_active          then return end
        if msg.vel == Velocity.release then return end
        if msg.y > 4                   then return end
        local column = self:calculate_track_position(msg.x,msg.y)
        if not column then return end
        -- todo implement me now
--        if column.note_value == AdjusterData.note.empty then
--            column.note_value         = pitch(self.note,self.octave)
--            column.instrument_value   = (self.instrument_idx - 1)
--            column.delay_value        = self.delay
--            column.panning_value      = self.pan
--            column.volume_value       = self.volume
--            if column.note_value == AdjusterData.note.off then
--                self.matrix[msg.x][msg.y] = self.color.note.off
--            else
--                self.matrix[msg.x][msg.y] = self.color.note.on
--            end
--        else
--            column.note_value         = AdjusterData.note.empty
--            column.instrument_value   = AdjusterData.instrument.empty
--            column.delay_value        = AdjusterData.delay.empty
--            column.panning_value      = AdjusterData.panning.empty
--            column.volume_value       = AdjusterData.volume.empty
--            self.matrix[msg.x][msg.y] = self.color.note.empty
--        end
--        self.pad:set_matrix(msg.x,msg.y,self.matrix[msg.x][msg.y])
    end
end


--- selected playback position
--
-- the green light that runs
--
function Adjuster:__register_playback_position_observer()
    self.playback_position_observer:register('stepper', function (line)
        if self.is_not_active then return end
        self:callback_playback_position(line)
    end)
end

function Adjuster:unregister_playback_position_observer()
    self.playback_position_observer:unregister('stepper' )
end











--- ======================================================================================================
---
---                                                 [ Pagination ]

function Adjuster:page_update_knobs()
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

function Adjuster:page_clear_knobs()
    self.pad:set_top(self.page_dec_idx,Color.off)
    self.pad:set_top(self.page_inc_idx,Color.off)
end

function Adjuster:page_inc()
    local pattern = self:active_pattern()
    if (self.page_end >= pattern.number_of_lines) then return end
    self.page = self.page + 1
    self:page_update_borders()
    self:page_update_knobs()
    self:refresh_matrix()
end

function Adjuster:page_dec()
    if(self.page_start <= 0 ) then return end
    self.page = self.page - 1
    self:page_update_borders()
    self:page_update_knobs()
    self:refresh_matrix()
end

function Adjuster:page_update_borders()
    self.page_start = ((self.page - 1) * 32 * self.zoom)
    self.page_end   = self.page_start + 1 + 32 * self.zoom
    -- print("update page borders", self.page, self.page_start, self.page_end)
end






--- ======================================================================================================
---
---                                                 [ ZOOM ]

function Adjuster:zoom_out()
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

function Adjuster:zoom_in()
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

function Adjuster:zoom_update_knobs()
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

function Adjuster:zoom_clear_knobs()
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
function Adjuster:line_to_point(line)
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
function Adjuster:point_to_line(x,y)
    return ((x + (8 * (y - 1))) - 1) * self.zoom + 1 + self.page_start
end

function Adjuster:refresh_matrix()
    self:__matrix_clear()
    self:__matrix_update()
    self:__render_matrix()
end

--- get the active pattern object
--
-- self.pattern_idx will be kept up to date by an observable notifier
--
function Adjuster:active_pattern()
    return renoise.song().patterns[self.pattern_idx]
end


--- calculates the position in track
--
-- the point should come from the launchpad.
-- the note_column that is selected will be taken in account
--
-- @return nil if nothing found
--
function Adjuster:calculate_track_position(x,y)
    local line       = self:point_to_line(x,y)
    local pattern    = self:active_pattern()
    local found_line = pattern.tracks[self.track_idx].lines[line]
    if found_line then
        return found_line.note_columns[self.track_column_idx]
    else
        return nil
    end
end



--- ======================================================================================================
---
---                                                 [ Rendering ]


--- update pad by the given matrix
--
function Adjuster:__render_matrix_position(x,y)
    if(self.matrix[x][y]) then
        self.pad:set_matrix(x,y,self.matrix[x][y])
    else
        self.pad:set_matrix(x,y,AdjusterData.color.clear)
    end
end

--- update memory-matrix by the current selected pattern
--
function Adjuster:__matrix_update()
    local pattern_iter  = renoise.song().pattern_iterator
    for pos,line in pattern_iter:lines_in_pattern_track(self.pattern_idx, self.track_idx) do
        if not table.is_empty(line.note_columns) then
            local note_column = line:note_column(self.track_column_idx)
            if(note_column.note_value ~= AdjusterData.note.empty) then
                local xy = self:line_to_point(pos.line)
                if xy then
                    local x = xy[1]
                    local y = xy[2]
                    if (y < 5 and y > 0) then
                        if (note_column.note_value == AdjusterData.note.off) then
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

function Adjuster:__matrix_clear()
    self.matrix = {}
    for x = 1, 8 do self.matrix[x] = {} end
end

function Adjuster:__render_matrix()
    for x = 1, 8 do
        for y = 1, 4 do
            self:__render_matrix_position(x,y)
        end
    end
end

--- updates the point that should blink on the launchpad
--
-- will be hooked in by the playback_position observable
--
function Adjuster:callback_playback_position(pos)
    if self.pattern_idx ~= pos.sequence then return end
    self:__clean_up_old_playback_position()
    local line = pos.line
    if (line <= self.page_start) then return end
    if (line >= self.page_end)   then return end
    local xy = self:line_to_point(line)
    if not xy then return end
    self:__set_playback_position(xy[1],xy[2])
end

function Adjuster:__set_playback_position(x,y)
    self.pad:set_matrix(x,y,self.color.stepper)
    self.playback_position_last_x = x
    self.playback_position_last_y = y
    self.removed_old_playback_position = true
end

function Adjuster:__clean_up_old_playback_position()
    if (self.removed_old_playback_position) then
        self:__render_matrix_position(
            self.playback_position_last_x,
            self.playback_position_last_y
        )
        self.removed_old_playback_position = nil
    end
end


