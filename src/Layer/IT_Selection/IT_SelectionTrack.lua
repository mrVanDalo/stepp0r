
function IT_Selection:_init_track()
    self.follow_track_instrument = nil
    self.track_idx = 1
    -- callbacks
    self:__create_selected_track_listener()
end

function IT_Selection:_boot_track()
    self.selected_track_listener()
end

function IT_Selection:_connect_track()
    add_notifier(renoise.song().selected_track_index_observable, self.selected_track_listener)
end

function IT_Selection:_disconnect_track()
    remove_notifier(renoise.song().selected_track_index_observable, self.selected_track_listener)
end

function IT_Selection:set_follow_track_instrument()
    self.follow_track_instrument = 1
end
function IT_Selection:unset_follow_track_instrument()
    self.follow_track_instrument = nil
end

function IT_Selection:__create_selected_track_listener()
    self.selected_track_listener = function()
        local new_track_idx = self:selected_track_index()
        if new_track_idx == self.track_idx then return end
        self:__update_track_index(new_track_idx)
    end
end


--- register callback
--
-- the callback gets the `index of instrument` and `the active note column`
function IT_Selection:register_select_instrument(callback)
    table.insert(self.callback_select_instrument, callback)
end


--- just update that the selected instrument was updated.
-- this is called by the selected_track_notifier
function IT_Selection:__update_track_index(track_index)
    self.track_idx       = track_index
    self.column_idx      = 1
    self:_update_instrument_index(self:__instrument_index_for_track(self.track_idx))
    -- trigger callbacks
    self:_update_alias_listener(self.track_idx, self.pattern_idx)
    self:__update_set_instrument_listeners()
end

--- return insturument index coresponding to the `track_index`
-- returns nil for not found
-- todo : move this to Renoise.instrument
function IT_Selection:__instrument_index_for_track(track_index)
    return table.find(Renoise.sequence_track:map_track(), track_index)
end



function IT_Selection:select_track_index(index)
    renoise.song().selected_track_index = index
end

function IT_Selection:selected_track_index()
    return renoise.song().selected_track_index
end


