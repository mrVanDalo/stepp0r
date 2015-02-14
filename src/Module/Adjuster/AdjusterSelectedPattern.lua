
--- ======================================================================================================
---
---                                                 [ Selected Pattern ]

function Adjuster:__init_selected_pattern()
    self:__create_select_pattern_listener()
end

function Adjuster:__activate_selected_pattern()
    self.pattern_idx = renoise.song().selected_pattern_index
    -- todo move this to the IT_Selection
    add_notifier(renoise.song().selected_pattern_index_observable, self.__select_pattern_listener)
end

function Adjuster:__deactivate_selected_pattern()
    remove_notifier(renoise.song().selected_pattern_index_observable, self.__select_pattern_listener)
end


--- selected pattern has changed listener
function Adjuster:__create_select_pattern_listener()
    self.__select_pattern_listener = function (_)
        if self.is_not_active then return end
        self.pattern_idx = renoise.song().selected_pattern_index
        self:_refresh_matrix()
    end
end
