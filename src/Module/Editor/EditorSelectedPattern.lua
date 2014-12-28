
--- ======================================================================================================
---
---                                                 [ Editor Selected Pattern Sub Module ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Chooser:__init_selected_pattern()
    self:__create_selected_pattern_index_notifier()
end
function Chooser:__activate_selected_pattern()
end
function Chooser:__deactivate_selected_pattern()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Editor:__create_selected_pattern_index_notifier()
    self.selected_pattern_index_notifier = function (_)
        self.pattern_idx = renoise.song().selected_pattern_index
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end
