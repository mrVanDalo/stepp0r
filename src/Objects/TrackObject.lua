


--- should take care of tracks, groups and instruments
class 'TrackObject'

function TrackObject:__init() end

function TrackObject:ensure_sequencer_track_idx_exist(track_idx)
    local nr_of_tracks    = self:sequencer_track_count()
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
function TrackObject:sequencer_track_sequence()
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
function TrackObject:sequencer_track_count()
    return renoise.song().sequencer_track_count
end

function TrackObject:rename_track_index(index, name)
    local track = renoise.song().tracks[index]
    if track then
        track.name = name
    end
end
