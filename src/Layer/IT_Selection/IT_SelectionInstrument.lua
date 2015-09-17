
function IT_Selection:_init_instrument()
    self.instrument_idx = 1
    self.callback_select_instrument = {}
end

--- register callback
--
-- the callback gets the `index of instrument` `index of track` and `the active note column`
function IT_Selection:register_select_instrument(callback)
    table.insert(self.callback_select_instrument, callback)
end

-- function :callback_set_instrument() return function(instrument_idx, track_idx, column_idx) end end
function IT_Selection:__update_set_instrument_listeners()
--    print("instrument_idx", self.instrument_idx)
--    print("track_idx", self.track_idx)
--    print("column_idx", self.column_idx)
    for _, callback in ipairs(self.callback_select_instrument) do
        callback(self.instrument_idx, self.track_idx, self.column_idx)
    end
end

--- return sequencer track of given instrument
function IT_Selection:track_for_instrument(instrument_number)
    local track_idx = self:track_index_for_instrument(instrument_number)
    return renoise.song().tracks[track_idx]
end

--- return sequencer track number of given instrument
function IT_Selection:track_index_for_instrument(instrument_number)
    Renoise.track:ensure_sequencer_track_idx_exist(instrument_number)
    return Renoise.track:sequencer_track_sequence()[instrument_number]
end


function IT_Selection:_update_instrument_index(instrument_idx)
    if (instrument_idx)  then
        self.instrument_idx = instrument_idx
        if (self.follow_track_instrument) then
            renoise.song().selected_instrument_index = self.instrument_idx
        end
    end
end

--- updated the selected instrument
-- don't call this on the selected_track_notifier
function IT_Selection:select_instrument(instrument_idx)
    local  name = Renoise.instrument:name_for_index(instrument_idx)
    if not name then return end
    self:_update_instrument_index(instrument_idx)
    self.track_idx          = self:track_index_for_instrument(self.instrument_idx)
    self.column_idx         = 1
    self:select_track_index(self.track_idx)
    Renoise.track:rename_index(self.track_idx, name)
    -- trigger callbacks
    self:__update_set_instrument_listeners()
end

