

--- ======================================================================================================
---
---                                                 [ Callbacks Sub-Module]

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]

function Adjuster:__init_callbacks()
    self:__create_callback_set_delay()
    self:__create_callback_set_volume()
    self:__create_callback_set_pan()
    self:__create_callback_set_bank()
end
function Adjuster:__activate_callbacks()
end
function Adjuster:__deactivate_callbacks()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Adjuster:__create_callback_set_delay()
    self.callback_set_delay =  function() end
end

function Adjuster:__create_callback_set_volume()
    self.callback_set_volume =  function() end
end

function Adjuster:__create_callback_set_pan()
    self.callback_set_pan =  function() end
end

function Adjuster:__create_callback_set_bank()
    self.callback_set_bank = function () end
end

