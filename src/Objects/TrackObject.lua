
--- ============================================================
--  All Tracks:
--
-- Functions to manipulate all tracks

class 'TrackObject'
function TrackObject:__init() end



--- return insturument index coresponding to the `track_index`
-- returns nil for not found
function TrackObject:instrument_idx(track_idx)
    return table.find(Renoise.sequence_track:map_track_idx(), track_idx)
end


--- rename a track
function TrackObject:rename_index(index, name)
    local track = renoise.song().tracks[index]
    if track then
        track.name = name
    end
end


function TrackObject:select_idx(track_idx)
    renoise.song().selected_track_index = track_idx
end
