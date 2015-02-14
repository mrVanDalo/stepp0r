
function IT_Selection:_init_instrument()
    self.instrument_idx = 1
    self.callback_select_instrument = {}
end

--- register callback
--
-- the callback gets the `index of instrument` and `the active note column`
function IT_Selection:register_select_instrument(callback)
    table.insert(self.callback_select_instrument, callback)
end


--- only instruments with names are instruments
function IT_Selection:__instrument_name(instrument)
    if not instrument then return nil end
    if not instrument.name then return nil end
    if instrument.name ~= "" then
        return instrument.name
    end
    if not instrument.midi_output_properties then
        return nil
    end
    if instrument.midi_output_properties.device_name == "" then
        return nil
    else
        return instrument.midi_output_properties.device_name
    end
end

--- return sequencer track of given instrument
function IT_Selection:track_for_instrument(instrument_number)
    local number = self:track_index_for_instrument(instrument_number)
    return renoise.song().tracks[number]
end

--- return sequencer track number of given instrument
function IT_Selection:track_index_for_instrument(instrument_number)
    self:__ensure_track_exist(instrument_number)
    -- calculate the correct track
    local counter = 0
    for index, track in pairs( renoise.song().tracks ) do
        if track.type == TrackData.type.sequencer and track.type ~= TrackData.type.group then
            counter = counter + 1
        end
        if counter == instrument_number then
            -- log('return track_number', counter)
            return index
        end
    end
end






-- function :callback_set_instrument() return function(instrument_idx, track_idx, column_idx) end end
function IT_Selection:__update_set_instrument_listeners()
    log("instrument_idx", self.instrument_idx)
    log("track_idx", self.track_idx)
    log("column_idx", self.column_idx)
    for _, callback in ipairs(self.callback_select_instrument) do
        callback(self.instrument_idx, self.track_idx, self.column_idx)
    end
end

--- updated the selected instrument
-- don't call this on the selected_track_notifier
function IT_Selection:select_instrument(instrument_idx)
    local found = renoise.song().instruments[instrument_idx]
    local  name = self:__instrument_name(found)
    if not name then return end
    self.instrument_idx     = instrument_idx
    self.track_idx          = self:track_index_for_instrument(self.instrument_idx)
    self.column_idx         = 1
    -- log("active instrument index ", instrument_idx)
    -- log("active track index", self.track_idx)
    self:select_track_index(self.track_idx)
    self:__rename_track_index(self.track_idx, name)
    -- trigger callbacks
    self:__update_set_instrument_listeners()
end

function IT_Selection:instrument_exists_p(instrument)
    if (self:__instrument_name(instrument)) then
        return true
    else
        return false
    end
end
