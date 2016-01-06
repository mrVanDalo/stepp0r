
--- ======================================================================================================
---
---                                                 [ Editor Launchpad Matrix Sub Module ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Editor:__init_launchpad_matrix()
    self:__create_pattern_matrix_listener()
end
function Editor:__activate_launchpad_matrix()
    self.pad:register_matrix_listener(self.__pattern_matrix_listener)
    self:_refresh_matrix()
end
function Editor:__deactivate_launchpad_matrix()
    self.pad:unregister_matrix_listener(self.__pattern_matrix_listener)
    self:__clear_pattern_matrix()
    self:__render_matrix()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Editor:_refresh_matrix()
    self:__clear_pattern_matrix()
    self:__update_pattern_matrix()
    self:__render_matrix()
end

function Editor:__create_pattern_matrix_listener()
    self.__pattern_matrix_listener = function (_,msg)
        if self.is_not_active          then return end
        if msg.vel == Velocity.release then return end
        if msg.y > 4                   then return end
        local column = self:calculate_track_position(msg.x,msg.y)
        if not column then return end
        if column.note_value == PatternEditorModuleData.note.empty then
            column.note_value         = pitch(self.note,self.octave)
            column.instrument_value   = (self.instrument_idx - 1)
            column.delay_value        = self.delay
            column.panning_value      = self.pan
            column.volume_value       = self.volume
        else
            column.note_value         = EditorData.note.empty
            column.instrument_value   = EditorData.instrument.empty
            column.delay_value        = EditorData.delay.empty
            column.panning_value      = EditorData.panning.empty
            column.volume_value       = EditorData.volume.empty
        end
        self:__set_pattern_matrix(msg.x,msg.y, column.note_value)
        self:__render_matrix_position(msg.x,msg.y)
    end
end

function Editor:__render_position_value(map, x,y)
    if     (map[x][y] == PatternEditorModuleData.note.on) then
        return EditorData.color_map.on
    elseif (map[x][y] == PatternEditorModuleData.note.off) then
        return EditorData.color_map.off
    else
        return EditorData.color_map.empty
    end
end
function Editor:__render_matrix_position(x,y)
    local active_value   =  self:__render_position_value(self.__pattern_matrix, x, y)
    local inactive_value =  self:__render_position_value(self.__pattern_matrix_inactive, x, y)
    local color = self.color[ EditorData.color_map.active_column * active_value + EditorData.color_map.inactive_column * inactive_value ]
    self.pad:set_matrix(x,y,color)
end
