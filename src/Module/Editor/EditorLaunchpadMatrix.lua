
--- ======================================================================================================
---
---                                                 [ Editor Launchpad Matrix Sub Module ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Chooser:__init_launchpad_matrix()
end
function Chooser:__activate_launchpad_matrix()
    self.pattern_idx = renoise.song().selected_pattern_index
    add_notifier(renoise.song().selected_pattern_index_observable, self.selected_pattern_index_notifier)
    self.pad:register_matrix_listener(self.pattern_matrix_listener)
end
function Chooser:__deactivate_launchpad_matrix()
    self:__render_matrix()
    remove_notifier(renoise.song().selected_pattern_index_observable, self.selected_pattern_index_notifier)
    self.pad:unregister_matrix_listener(self.pattern_matrix_listener)
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]



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



