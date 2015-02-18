
--- ======================================================================================================
---
---                                                 [ Selected Pattern ]

function Adjuster:__init_selected_pattern()
--    self.pattern_idx = 1
--    self:__create_callback_set_pattern()
end

function Adjuster:__activate_selected_pattern()
end

function Adjuster:__deactivate_selected_pattern()
end


--- selected pattern has changed listener
--function Adjuster:__create_callback_set_pattern()
--    self.callback_set_pattern = function (index)
--        if self.is_not_active then return end
--        self.pattern_idx = index
--        self:_refresh_matrix()
--    end
--end
