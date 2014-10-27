--- ======================================================================================================
---
---                                                 [ Instrument and Track Selection Layer ]
---
--- To keep track of instruments, tracks and track column selection.
---
--- more of a on top of Track and Instrument abstraction Layer

TrackData = {
    type = {
        sequencer = renoise.Track.TRACK_TYPE_SEQUENCER,
        master = renoise.Track.TRACK_TYPE_MASTER,
        send = renoise.Track.TRACK_TYPE_SEND,
        group = renoise.Track.TRACK_TYPE_GROUP,
    },
    mute = {
        active = renoise.Track.MUTE_STATE_ACTIVE,
        off = renoise.Track.MUTE_STATE_OFF,
        muted = renoise.Track.MUTE_STATE_MUTED,
    },
}

class "IT_Selection"



--- ======================================================================================================
---
---                                                 [ INIT ]


function IT_Selection:__init()
    self.instrument_idx = 1
    self.track_idx      = 1
    self.column_idx     = 1
    -- callbacks
    self.callback_select_instrument = {}
    self:create_listeners()
end

function IT_Selection:create_listeners()
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

--- boot the layer (basically trigger all listeners)
function IT_Selection:boot()
    self.selected_track_listener()
end





--- ======================================================================================================
---
---                                                 [ boot ]

function IT_Selection:connect()
    renoise.song().selected_track_index_observable:add_notifier(self.selected_track_listener)
end

function IT_Selection:disconnect()
    if (renoise.song().selected_track_index_observable:has_notifier(self.selected_track_listener)) then
        renoise.song().selected_track_index_observable:remove_notifier(self.selected_track_listener)
    end
end








--- ======================================================================================================
---
---                                                 [ lib ]

function IT_Selection:ensure_column_idx_exists()
    local track = self:track_for_instrument(self.instrument_idx)
    if track.visible_note_columns < self.column_idx then
        track.visible_note_columns = self.column_idx
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


function IT_Selection:select_track_index(index)
    renoise.song().selected_track_index = index
end

function IT_Selection:selected_track_index()
    return renoise.song().selected_track_index
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


-- function :callback_set_instrument() return function(instrument_idx, track_idx, column_idx) end end
function IT_Selection:__update_set_instrument_listeners()
    log("instrument_idx", self.instrument_idx)
    log("track_idx", self.track_idx)
    log("column_idx", self.column_idx)
    for _, callback in ipairs(self.callback_select_instrument) do
        callback(self.instrument_idx, self.track_idx, self.column_idx)
    end
end

--- just update that the selected instrument was updated.
-- this is called by the selected_track_notifier
function IT_Selection:__update_track_index(track_index)
    self.track_idx      = track_index
    self.column_idx     = 1
    self.instrument_idx = self:__instrument_index_for_track(self.track_idx)
    -- trigger callbacks
    self:__update_set_instrument_listeners()
end

--- return insturument index coresponding to the `track_index`
-- todo fixme (what about not existing instrument indexes?)
function IT_Selection:__instrument_index_for_track(track_index)
    local counter = 0
    for index, track in pairs( renoise.song().tracks ) do
        if track.type == TrackData.type.sequencer then
            counter = counter + 1
        end
        if index == track_index then
            -- log('return instrument index ', counter)
            return counter
        end
    end
end






--- ======================================================================================================
---
---                                                 [ track tmp area ]



function IT_Selection:__rename_track_index(index, name)
    local track = renoise.song().tracks[index]
    if track then
        track.name = name
    end
end

--- number of sequencer tracks
function IT_Selection:__number_of_sequencer_tracks()
    local counter = 0
    for _, track in pairs( renoise.song().tracks ) do
        if track.type == TrackData.type.sequencer then
            counter = counter + 1
        end
    end
    return counter
end

--- last track befor the master track
function IT_Selection:__last_of_tracks()
    return renoise.song().sequencer_track_count
end

--- ensure the `track_nr` exist, if not create enought tracks
-- to make it exist.
-- sequencer tracks a meant by track
-- but the given `track_nr` must be the _absolute_ track number
function IT_Selection:__ensure_track_exist(track_nr)
    --    log("ensure track number exists", track_nr)
    local nr_of_tracks = self:__number_of_sequencer_tracks()
    --    log("nr_of_tracks", nr_of_tracks)
    if (nr_of_tracks < track_nr) then
        -- put missings tracks on last possion
        -- untill we reach the track
        local how_many_to_add = track_nr -  nr_of_tracks
        local last_of_tracks = self:__last_of_tracks()
        for _ = 1, how_many_to_add do
            renoise.song():insert_track_at(last_of_tracks + 1)
        end
    end
end
