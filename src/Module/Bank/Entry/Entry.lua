
class "Entry"

-- fixme : remove this?
Entry.instrument = {
    empty = 255
}
-- fixme: remove this?
Entry.delay = {
    empty = 0
}
-- fixme : remove this?
Entry.volumen= {
    empty = 255
}
-- fixme : remove this?
Entry.panning = {
    empty = 255
}

Entry.note = {
    empty = {
        pitch = NewNote.empty.pitch,
        delay = Entry.delay.empty,
        pan   = Entry.panning.empty,
        vol   = Entry.volumen.empty,
    }
}

Entry.SELECTED   = 1
Entry.UNSELECTED = 2


function Entry:__init(self) end

--- returns the current line
--> [renoise.PatternLine object]
function Entry:get_line(line, active_pattern, track_idx)
    return active_pattern.tracks[track_idx].lines[line]
end
