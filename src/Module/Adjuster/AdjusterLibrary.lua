--- ======================================================================================================
---
---                                                 [ Library ]

--- calculate all the lines hidden behind a point on the matrix
function Adjuster:point_to_line_interval(x,y)
    local line_start = ((x + (8 * (y - 1))) - 1) * self.zoom + 1 + self.page_start
    local line_stop  = line_start + (self.zoom - 1)
    return {line_start, line_stop}
end

function Adjuster:_get_line(line)
    local pattern    = self:active_pattern()
    local found_line = pattern.tracks[self.track_idx].lines[line]
    if found_line then
        return found_line.note_columns[self.track_column_idx]
    else
        return nil
    end
end
