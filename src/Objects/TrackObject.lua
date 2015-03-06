


--- should take care of tracks, groups and instruments
class 'TrackObject'

function TrackObject:__init() end

--- @return track of given instrument index
function TrackObject:track_for_instrument_index(instrument_number)
    local number = self:track_index_for_instrument_index(instrument_number)
    return renoise.song().tracks[number]
end

--- @return track number of given instrument index
function TrackObject:track_index_for_instrument_index(instrument_number)
    -- todo finish me (i'm not working yet)
    --    self:__ensure_track_exist(instrument_number)
    -- calculate the correct track
    local counter = 0
    for index, track in pairs( renoise.song().tracks ) do
        if track.type == renoise.Track.TRACK_TYPE_SEQUENCER
                and track.type ~= renoise.Track.TRACK_TYPE_GROUP
        then
            counter = counter + 1
        end
        if counter == instrument_number then
            -- log('return track_number', counter)
            return index
        end
    end
end

function TrackObject:ensure_track_idx_exist(track_idx)
    local nr_of_tracks    = self:track_sequence_size()
    local how_many_to_add = track_idx -  nr_of_tracks
    if (how_many_to_add > 0) then
        -- put missings tracks on last possion
        -- untill we reach the track
        local last_of_sequencer_tracks  = renoise.song().sequencer_track_count
        for _ = 1, how_many_to_add do
            renoise.song():insert_track_at(last_of_sequencer_tracks + 1)
        end
    end
end

--- sequence of all tracks
-- excluding send tracks and groups
function TrackObject:track_sequence()
    local sequence_idx = 1
    local track_idx    = 1
    local sequence = {}
    for _, track in pairs( renoise.song().tracks ) do
        if track.type == renoise.Track.TRACK_TYPE_SEQUENCER then
            sequence[sequence_idx] = track_idx
            sequence_idx = sequence_idx + 1
        end
        track_idx = track_idx + 1
    end
    return sequence
end

--- use this function only if you don't need the track_sequence itself.
function TrackObject:track_sequence_size()
    -- fixme : isn't this coverd by : renoise.song().sequencer_track_count ?
    local sequence_idx = 1
    for _, track in pairs( renoise.song().tracks ) do
        if track.type == renoise.Track.TRACK_TYPE_SEQUENCER then
            sequence_idx = sequence_idx + 1
        end
    end
    return sequence_idx
end

