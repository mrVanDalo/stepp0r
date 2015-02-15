

function IT_Selection:_init_pattern()
    self.pattern_idx = 1
    self.last_alias_track_idx = self.track_idx
    self.last_alias_pattern_idx = self.pattern_idx
    self.callback_select_pattern = {}
    self:__create_select_pattern_listener()
    self:__create_alias_pattern_listener()
end

function IT_Selection:_boot_pattern()
    self.__select_pattern_listener()
end

function IT_Selection:_connect_pattern()
    add_notifier(renoise.song().selected_pattern_index_observable, self.__select_pattern_listener)
    self:_update_alias_listener(self.track_idx, self.pattern_idx)
end

function IT_Selection:_disconnect_pattern()
    remove_notifier(renoise.song().selected_pattern_index_observable, self.__select_pattern_listener)
    self:__remove_alias_listener()
end

--- selected pattern has changed listener
function IT_Selection:__create_select_pattern_listener()
    self.__select_pattern_listener = function (_)
        self.pattern_idx = renoise.song().selected_pattern_index
        print("changed pattern index", self.pattern_idx)
        self:_update_alias_listener(self.track_idx, self.pattern_idx)
        self:__update_set_pattern_listeners()
    end
end

function IT_Selection:_update_alias_listener(new_track_idx, new_pattern_idx)
    remove_notifier(
        renoise.song().patterns[self.last_alias_pattern_idx].tracks[self.last_alias_track_idx].alias_pattern_index_observable,
        self.__alias_pattern_listener
    )
    print("switch track_idx", self.last_alias_track_idx, new_track_idx)
    print("switch pattern_idx", self.last_alias_pattern_idx, new_pattern_idx)
    self.last_alias_track_idx = new_track_idx
    self.last_alias_pattern_idx = new_pattern_idx
    add_notifier(
        renoise.song().patterns[self.last_alias_pattern_idx].tracks[self.last_alias_track_idx].alias_pattern_index_observable,
--        renoise.song().selected_track.alias_pattern_index_observable,
        self.__alias_pattern_listener
    )
end

function IT_Selection:__remove_alias_listener()
    remove_notifier(
        renoise.song().patterns[self.last_alias_pattern_idx].tracks[self.last_alias_track_idx].alias_pattern_index_observable,
        self.__alias_pattern_listener
    )
end

function IT_Selection:__create_alias_pattern_listener()
    self.__alias_pattern_listener = function (_)
        self.pattern_idx = renoise.song().selected_pattern_index
        print("changed alias pattern index", self.pattern_idx)
        self:__update_set_pattern_listeners()
    end
end

--- register callback
--
-- the callback gets the `index of pattern`
function IT_Selection:register_select_pattern(callback)
    table.insert(self.callback_select_pattern, callback)
end

-- function :callback_set_instrument() return function(instrument_idx, track_idx, column_idx) end end
function IT_Selection:__update_set_pattern_listeners()
    for _, callback in ipairs(self.callback_select_pattern) do
        callback(self.pattern_idx)
    end
end
