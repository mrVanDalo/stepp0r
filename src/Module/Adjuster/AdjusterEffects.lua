

--- ======================================================================================================
---
---                                                 [ Callbacks Sub-Module]

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]

function Adjuster:__init_effects()
    self:__create_callback_set_delay()
    self:__create_callback_set_volume()
    self:__create_callback_set_pan()
end
function Adjuster:__activate_effects()
end
function Adjuster:__deactivate_effects()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Adjuster:__create_callback_set_delay()
    self.callback_set_delay = function() end
end

function Adjuster:__create_callback_set_volume()
    self.callback_set_volume = function() end
end

function Adjuster:__create_callback_set_pan()
    self.callback_set_pan = function() end
end


