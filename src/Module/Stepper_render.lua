--- ======================================================================================================
---
---                                                 [ Rendering ]


--- update pad by the given matrix
--
function Stepper:__render_matrix_position(x,y)
    if(self.matrix[x][y]) then
        self.pad:set_matrix(x,y,self.matrix[x][y])
    else
        self.pad:set_matrix(x,y,StepperData.color.clear)
    end
end

--- update memory-matrix by the current selected pattern
--
function Stepper:__matrix_update()
    local pattern_iter  = renoise.song().pattern_iterator
    for pos,line in pattern_iter:lines_in_pattern_track(self.pattern_idx, self.track_idx) do
        if not table.is_empty(line.note_columns) then
            local note_column = line:note_column(self.track_column_idx)
            if(note_column.note_value ~= StepperData.note.empty) then
                local xy = self:line_to_point(pos.line)
                if xy then
                    local x = xy[1]
                    local y = xy[2]
                    if (y < 5 and y > 0) then
                        if (note_column.note_value == StepperData.note.off) then
                            self.matrix[x][y] = self.color.note.off
                        else
                            self.matrix[x][y] = self.color.note.on
                        end
                    end
                end
            end
        end
    end
end

function Stepper:__matrix_clear()
    self.matrix = {}
    for x = 1, 8 do self.matrix[x] = {} end
end

function Stepper:__render_matrix()
    for x = 1, 8 do
        for y = 1, 4 do
            self:__render_matrix_position(x,y)
        end
    end
end

--- updates the point that should blink on the launchpad
--
-- will be hooked in by the playback_position observable
--
function Stepper:callback_playback_position(pos)
    if self.pattern_idx ~= pos.sequence then return end
    self:__clean_up_old_playback_position()
    local line = pos.line
    if (line <= self.page_start) then return end
    if (line >= self.page_end)   then return end
    local xy = self:line_to_point(line)
    if not xy then return end
    self:__set_playback_position(xy[1],xy[2])
end

function Stepper:__set_playback_position(x,y)
    self.pad:set_matrix(x,y,self.color.stepper)
    self.playback_position_last_x = x
    self.playback_position_last_y = y
    self.removed_old_playback_position = true
end

function Stepper:__clean_up_old_playback_position()
    if (self.removed_old_playback_position) then
        self:__render_matrix_position(
            self.playback_position_last_x,
            self.playback_position_last_y
        )
        self.removed_old_playback_position = nil
    end
end

