
--- ======================================================================================================
---
---                                                 [ Editor Selected Pattern Sub Module ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Editor:__init_selected_pattern()
--    self.pattern_idx      = 1 -- actual pattern
--    self:__create_callback_set_pattern()
end
function Editor:__activate_selected_pattern()
end
function Editor:__deactivate_selected_pattern()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

--function Editor:__create_callback_set_pattern()
--    self.callback_set_pattern = function (index)
--        self.pattern_idx = index
--        if self.is_active then
--            self:_refresh_matrix()
--        end
--    end
--end

--- get the active pattern object
--
-- self.pattern_idx will be kept up to date by an observable notifier
--
--function Editor:active_pattern()
--    return renoise.song().patterns[self.pattern_idx]
--end
