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
    self:_zoom_update_knobs()
    self.pad:register_top_listener(self.__zoom_listener)
    -- pagination
    self:_page_update_knobs()
    self.pad:register_top_listener(self.__page_listener)
    -- main matrix
    self:_refresh_matrix()
    self.pad:register_matrix_listener(self.__matrix_listener)
end

--- tear down
--
function Adjuster:_deactivate()
    -- clear connected layers
    self:_page_clear_knobs()
    self:_zoom_clear_knobs()
    self:_matrix_clear()
    self:_render_matrix()
    -- unregister notifiers/listeners
    self:unregister_playback_position_observer()
    remove_notifier(renoise.song().selected_pattern_index_observable, self.__select_pattern_listener)
    self:pad:unregister_top_listener(self.__zoom_listener)
    self.pad:unregister_top_listener(self.__page_listener)
    self:pad:unregister_matrix_listener(self.__matrix_listener)
end







--- selected pattern has changed listener
function Adjuster:__create_select_pattern_listener()
    self.__select_pattern_listener = function (_)
        if self.is_not_active then return end
        self.pattern_idx = renoise.song().selected_pattern_index
        self:_refresh_matrix()
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
            self:_page_inc()
        elseif msg.x == self.page_dec_idx then
            self:_page_dec()
        end
    end
end
--- pad matrix listener
--
-- listens on click events on the launchpad matrix
function Adjuster:__create_matrix_listener()
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
-- todo replace by standard renoise lua convention
function Adjuster:__register_playback_position_observer()
    self.playback_position_observer:register('stepper', function (line)
        if self.is_not_active then return end
        self:callback_playback_position(line)
    end)
end

function Adjuster:unregister_playback_position_observer()
    self.playback_position_observer:unregister('stepper' )
end

