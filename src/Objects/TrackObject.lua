

--- should take care of tracks, groups and instruments
class 'TrackObject'

function TrackObject:__init() end







--- ============================================================
--  Sequencer Tracks :
--
--  Tracks excluding Groups and Send Tracks
--  Them should accourd to an instrument

-- creates a sequencer track if the track index does not exist
function TrackObject:ensure_sequencer_track_idx_exist(track_idx)
    local nr_of_tracks    = self:sequencer_track_count()
    local how_many_to_add = track_idx -  nr_of_tracks
    if (how_many_to_add > 0) then
        -- put missings tracks on last possion
        -- untill we reach the track
        -- need to use the renoise.song() version here
        local last_of_sequencer_tracks  = renoise.song().sequencer_track_count
        for _ = 1, how_many_to_add do
            renoise.song():insert_track_at(last_of_sequencer_tracks + 1)
        end
    end
end

-- A mapping from sequencer_track_index to all_track_index
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

-- A mapping from sequencer_track_index -> group_idx
function TrackObject:sequencer_track_group()
    local sequence_idx = 1
    local track_idx    = 1
    local group_idx    = 1
    local group_name   = ""
    local sequence = {}
    for _, track in pairs( renoise.song().tracks ) do
        if track.type == renoise.Track.TRACK_TYPE_SEQUENCER then
            if track.group_parent and group_name ~= track.group_parent.name then
                -- group name changed
                group_idx = group_idx + 1
                group_name = track.group_parent.name
            elseif (not track.group_parent) and group_name ~= "" then
                -- no parent and group name is still set
                group_idx = group_idx + 1
                group_name = ""
            end
            sequence[sequence_idx] = group_idx
            sequence_idx = sequence_idx + 1
        end
        track_idx = track_idx + 1
    end
    return sequence
end

-- the all_track_idx for a sequence idx
function TrackObject:track_idx_for_sequence_idx(sequence_idx)
    return self:sequencer_track_sequence()[sequence_idx]
end

-- the group number a sequence track belongs to (group number starts at 1)
function TrackObject:group_idx_for_sequence_idx(sequence_idx)
    return self:sequencer_track_group()[sequence_idx]
end


-- total number of sequencer tracks
function TrackObject:sequencer_track_count()
    local sequence_idx = 1
    local track_idx    = 1
    for _, track in pairs( renoise.song().tracks ) do
        if track.type == renoise.Track.TRACK_TYPE_SEQUENCER then
            sequence_idx = sequence_idx + 1
        end
        track_idx = track_idx + 1
    end
    return sequence_idx - 1
end








--- ============================================================
--  All Tracks:
--
-- Functions to manipulate all tracks
--

-- rename a track
function TrackObject:rename_index(index, name)
    local track = renoise.song().tracks[index]
    if track then
        track.name = name
    end
end
