--- ======================================================================================================
---
---                                                 [ PatternEditorModule ]
---
-- the green light that runs on the matrix to show the playback position
--


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]

function PatternEditorModule:__init_playback_position()
    self.playback_position_observer = nil
    self.playback_position_last_x = 1
    self.playback_position_last_y = 1
    --
    self.only_selected_pattern_playback_position = false
    --
    self:__create_callback_playback_positions()
end

function PatternEditorModule:__activate_playback_position()
    self:__register_playback_position_observer()
end

function PatternEditorModule:__deactivate_playback_position()
    self:__unregister_playback_position_observer()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Public ]

function PatternEditorModule:wire_playback_position_observer(playback_position_observer)
    if self.playback_position_observer then
        self:__unregister_playback_position_observer()
    end
    self.playback_position_observer = playback_position_observer
end


--- ======================================================================================================
---
---                                                 [ Lib ]

function PatternEditorModule:__register_playback_position_observer()
    if self.only_selected_pattern_playback_position then
        self.playback_position_observer:register( self.playback_key , self.callback_playback_position_current_sequence )
    else
        self.playback_position_observer:register( self.playback_key , self.callback_playback_position_ignore_sequence )
    end
end
function PatternEditorModule:set_selected_pattern_playback_position(only_current)
--    print("only current ", only_current)
--    print("self.only current ", self.only_selected_pattern_playback_position)
    self.only_selected_pattern_playback_position = only_current
end

function PatternEditorModule:__unregister_playback_position_observer()
    self.playback_position_observer:unregister( self.playback_key )
end

function PatternEditorModule:__create_callback_playback_positions()
    self.callback_playback_position_current_sequence = function (pos)
        if self.is_not_active then return end
        if Renoise.pattern_editor:is_selected_pattern_played() then
            self:__render_playback_position(pos.line)
        end
    end
    self.callback_playback_position_ignore_sequence = function (pos)
        if self.is_not_active then return end
        self:__render_playback_position(pos.line)
    end
end

function PatternEditorModule:__render_playback_position(line)
    -- clean up old playback position
    if (self.removed_old_playback_position) then
        self:__render_matrix_position(
            self.playback_position_last_x,
            self.playback_position_last_y
        )
        self.removed_old_playback_position = nil
    end
    -- update position
    if (line <= self.page_start) then return end
    if (line >= self.page_end)   then return end
    local xy = self:line_to_point(line)
    if not xy then return end
    -- set playback position
    local x = xy[1]
    local y = xy[2]
    self.pad:set_matrix(x,y,self.color.stepper)
    self.playback_position_last_x = x
    self.playback_position_last_y = y
    self.removed_old_playback_position = true
end

