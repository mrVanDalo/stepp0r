
--- ======================================================================================================
---
---                                                 [ Pattern Matrix Sub-Module]
---

--- this submodule is just for showing how the pattern looks like, and render it to the Launchpad


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]

function Adjuster:__init_pattern()
--    self.__pattern_matrix = {}
end

function Adjuster:__activate_pattern()
    -- done by  __activate_render
end

function Adjuster:__deactivate_pattern()
    self:__clear_pattern_matrix()
end


