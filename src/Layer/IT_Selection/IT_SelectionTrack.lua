
function IT_Selection:_init_track()
    -- callbacks
    self.track_idx      = 1

    self:__create_selected_track_listener()
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

--- boot the layer (basically trigger all listeners)
function IT_Selection:boot()
    self.selected_track_listener()
end

function IT_Selection:select_track_index(index)
    renoise.song().selected_track_index = index
end

function IT_Selection:selected_track_index()
    return renoise.song().selected_track_index
end

function IT_Selection:__rename_track_index(index, name)
    local track = renoise.song().tracks[index]
    if track then
        track.name = name
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
