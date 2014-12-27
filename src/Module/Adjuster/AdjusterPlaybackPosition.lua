--- ======================================================================================================
---
---                                                 [ Adjuster Playback Position Module ]
---
-- the green light that runs on the matrix to show the playback position
--


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]

function Adjuster:__init_playback_position()
    self.playback_position_observer = nil
    self.playback_position_last_x = 1
    self.playback_position_last_y = 1
end

function Adjuster:__activate_playback_position()
    self:__register_playback_position_observer()
end

function Adjuster:__deactivate_playback_position()
    self:__unregister_playback_position_observer()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Public ]

function Adjuster:wire_playback_position_observer(playback_position_observer)
    if self.playback_position_observer then
        self:__unregister_playback_position_observer()
    end
    self.playback_position_observer = playback_position_observer
end


--- ======================================================================================================
---
---                                                 [ Lib ]

function Adjuster:__register_playback_position_observer()
    self.playback_position_observer:register('adjuster', function (line)
        if self.is_not_active then return end
        self:__callback_playback_position(line)
    end)
end

function Adjuster:__unregister_playback_position_observer()
    self.playback_position_observer:unregister('stepper' )
end

--- updates the point that should blink on the launchpad
--
-- will be hooked in by the playback_position observable
--
function Adjuster:__callback_playback_position(pos)
    if self.pattern_idx ~= pos.sequence then return end
    -- clean up old playback position
    if (self.removed_old_playback_position) then
        self:_render_matrix_position(
            self.playback_position_last_x,
            self.playback_position_last_y
        )
        self.removed_old_playback_position = nil
    end
    -- update position
    local line = pos.line
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
