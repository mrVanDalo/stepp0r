
function IT_Selection:_init_instrument()
    self.instrument_idx = 1
    self.callback_select_instrument = {}
    self.instrument_fingerprint = ""
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

function IT_Selection:sync_track_with_instrument()
    local fingerprint = Renoise.instrument:fingerprint()
    if fingerprint == self.instrument_fingerprint then return end
    self.instrument_fingerprint = fingerprint

    Renoise.sequence_track:ensure_exist(Renoise.instrument:last_idx())
end

function IT_Selection:_update_instrument_index(instrument_idx)
    if (instrument_idx)  then
        self.instrument_idx = instrument_idx
        if (self.follow_track_instrument) then
            Renoise.instrument:select_idx(instrument_idx)
        end
    end
end


--- updated the selected instrument
-- don't call this on the selected_track_notifier
function IT_Selection:select_instrument(instrument_idx)
    local  name = Renoise.instrument:name_for_index(instrument_idx)
    if not name then return end
    self:sync_track_with_instrument()
    self:_update_instrument_index(instrument_idx)
    self.track_idx          = Renoise.sequence_track:track_idx(self.instrument_idx)
    self.column_idx         = 1
    self:select_track_index(self.track_idx)
    Renoise.track:rename_index(self.track_idx, name)
    -- trigger callbacks
    self:__update_set_instrument_listeners()
end

