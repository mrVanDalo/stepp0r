

--- ======================================================================================================
---
---                                                 [ Editor Library Sub Module ]

--- everything I don't know where to put else

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Chooser:__init_library()
end
function Chooser:__activate_library()
end
function Chooser:__deactivate_library()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

--- calculate point (for matrix) of line
--
-- nil for is not on the matrix
--
function Editor:line_to_point(line)
    -- page
    local l = line - self.page_start
    if l < 1 then return end
    -- zoom
    local li = l
    if (self.zoom > 1) then
        if ((l - 1) % self.zoom) ~= 0 then return end
        li = ((l - 1) / self.zoom) + 1
    end
    -- transformation
    local x = ((li - 1) % 8) + 1
    local y = math.floor((li - 1) / 8) + 1
    return {x,y}
end

--- calculate the line a point given by the actual matrix configuration
--
-- point_to_line(line_to_point(l)) == l should allways be true ?
--
function Editor:point_to_line(x,y)
    return ((x + (8 * (y - 1))) - 1) * self.zoom + 1 + self.page_start
end

--- calculates the position in track
--
-- the point should come from the launchpad.
-- the note_column that is selected will be taken in account
--
-- @return nil if nothing found
--
function Editor:calculate_track_position(x,y)
    local line       = self:point_to_line(x,y)
    local pattern    = self:active_pattern()
    local found_line = pattern.tracks[self.track_idx].lines[line]
    if found_line then
        return found_line.note_columns[self.track_column_idx]
    else
        return nil
    end
end
