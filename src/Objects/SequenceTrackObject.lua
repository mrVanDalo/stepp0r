
--- ============================================================
--  Sequencer Tracks :
--
--  Tracks excluding Groups and Send Tracks
--  Them should accourd to an instrument
--
--  Sequence Tracks kinda respond to the Instruments

class 'SequenceTrackObject'
function SequenceTrackObject:__init() end


-- creates a sequencer track if the track index does not exist
function SequenceTrackObject:ensure_exist(track_idx)
    local nr_of_tracks    = self:count()
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
function SequenceTrackObject:map_track_idx()
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
function SequenceTrackObject:track_idx(sequence_idx)
    return self:map_track_idx()[sequence_idx]
end

-- total number of sequencer tracks
function SequenceTrackObject:count()
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

















--- ====================================================================================================
--- Groups:
--
-- Theses Groups correspond to the Grouping of tracks you do.
-- We just iterate them from left to right (starting by 1).
-- If there is a track not contained in a group between two groups, we give it a group index on its own.

--- A mapping from sequencer_track_index -> group_idx
function SequenceTrackObject:map_group_idx()
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


--- the group number a sequence track belongs to (group number starts at 1)
function SequenceTrackObject:group_idx(sequence_idx)
    return self:map_group_idx()[sequence_idx]
end

--- returns a group class (0 or 1) (no nil will be returned)
---
--- the index must be the sequence_track index (not the track index)
function SequenceTrackObject:group_type_2(sequence_idx)
    local group_idx = self:group_idx(sequence_idx)
    if group_idx then
        return group_idx % 2
    else
        return 1
    end
end
