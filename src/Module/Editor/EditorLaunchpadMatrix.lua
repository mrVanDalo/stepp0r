
--- ======================================================================================================
---
---                                                 [ Editor Launchpad Matrix Sub Module ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Editor:__init_launchpad_matrix()
    self.matrix      = {}
    self:__create_pattern_matrix_listener()
end
function Editor:__activate_launchpad_matrix()
    self.pattern_idx = renoise.song().selected_pattern_index
    add_notifier(renoise.song().selected_pattern_index_observable, self.selected_pattern_index_notifier)
    self.pad:register_matrix_listener(self.pattern_matrix_listener)
    self:_refresh_matrix()
end
function Editor:__deactivate_launchpad_matrix()
    self:__render_matrix()
    remove_notifier(renoise.song().selected_pattern_index_observable, self.selected_pattern_index_notifier)
    self.pad:unregister_matrix_listener(self.pattern_matrix_listener)
    self:__matrix_clear()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Editor:_refresh_matrix()
    self:__matrix_clear()
    self:__matrix_update()
    self:__render_matrix()
end

function Editor:__create_pattern_matrix_listener()
    self.pattern_matrix_listener = function (_,msg)
        if self.is_not_active          then return end
        if msg.vel == Velocity.release then return end
        if msg.y > 4                   then return end
        local column           = self:calculate_track_position(msg.x,msg.y)
        if not column then return end
        if column.note_value == EditorData.note.empty then
            column.note_value         = pitch(self.note,self.octave)
            column.instrument_value   = (self.instrument_idx - 1)
            column.delay_value        = self.delay
            column.panning_value      = self.pan
            column.volume_value       = self.volume
            if column.note_value == EditorData.note.off then
                self.matrix[msg.x][msg.y] = self.color.note.off
            else
                self.matrix[msg.x][msg.y] = self.color.note.on
            end
        else
            column.note_value         = EditorData.note.empty
            column.instrument_value   = EditorData.instrument.empty
            column.delay_value        = EditorData.delay.empty
            column.panning_value      = EditorData.panning.empty
            column.volume_value       = EditorData.volume.empty
            self.matrix[msg.x][msg.y] = self.color.note.empty
        end
        self.pad:set_matrix(msg.x,msg.y,self.matrix[msg.x][msg.y])
    end
end



--- update pad by the given matrix
--
function Editor:__render_matrix_position(x,y)
    if(self.matrix[x][y]) then
        self.pad:set_matrix(x,y,self.matrix[x][y])
    else
        self.pad:set_matrix(x,y,EditorData.color.clear)
    end
end

--- update memory-matrix by the current selected pattern
--
function Editor:__matrix_update()
    local pattern_iter  = renoise.song().pattern_iterator
    for pos,line in pattern_iter:lines_in_pattern_track(self.pattern_idx, self.track_idx) do
        if not table.is_empty(line.note_columns) then
            local note_column = line:note_column(self.track_column_idx)
            if(note_column.note_value ~= EditorData.note.empty) then
                local xy = self:line_to_point(pos.line)
                if xy then
                    local x = xy[1]
                    local y = xy[2]
                    if (y < 5 and y > 0) then
                        if (note_column.note_value == EditorData.note.off) then
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

function Editor:__matrix_clear()
    self.matrix = {}
    for x = 1, 8 do self.matrix[x] = {} end
end

function Editor:__render_matrix()
    for x = 1, 8 do
        for y = 1, 4 do
            self:__render_matrix_position(x,y)
        end
    end
end

