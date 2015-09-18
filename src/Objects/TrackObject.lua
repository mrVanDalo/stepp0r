
--- ============================================================
--  All Tracks:
--
-- Functions to manipulate all tracks

class 'TrackObject'
function TrackObject:__init() end







--- rename a track
function TrackObject:rename_index(index, name)
    local track = renoise.song().tracks[index]
    if track then
        track.name = name
    end
end
