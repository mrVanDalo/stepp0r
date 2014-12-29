
--- ======================================================================================================
---
---                                                 [ Editor Effects Sub Module ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Chooser:__init_effects()
    self:__create_callback_set_delay()
    self:__create_callback_set_volume()
    self:__create_callback_set_pan()
end
function Chooser:__activate_effects()
end
function Chooser:__deactivate_effects()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Editor:__create_callback_set_delay()
    self.callback_set_delay =  function (delay)
        self.delay = delay
    end
end
function Editor:__create_callback_set_volume()
    self.callback_set_volume = function (volume)
        self.volume = volume
    end
end
function Editor:__create_callback_set_pan()
    self.callback_set_pan =  function (pan)
        self.pan = pan
    end
end
