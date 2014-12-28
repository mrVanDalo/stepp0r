--- ======================================================================================================
---
---                                                 [ Mode Control ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Chooser:__init_mode()
    self.mode          = ChooserData.mode.choose
    self.mode_idx      = self.row
    self:__create_mode_listener()
end
function Chooser:__activate_mode()
    self:__mode_update_knobs()
    self.pad:register_right_listener(self.mode_listener)
end
function Chooser:__deactivate_mode()
    self:__mode_clear_knobs()
    self.pad:unregister_right_listener(self.mode_listener)
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Chooser:__create_mode_listener()
    self.mode_listener = function (_,msg)
        if self.is_not_active          then return end
        if msg.vel == Velocity.release then return end
        if msg.x   ~= self.mode_idx    then return end
        self:__mode_next()
        self:__mode_update_knobs()
    end
end

function Chooser:__mode_next()
    if self.mode == ChooserData.mode.choose then
        self.mode = ChooserData.mode.mute
    elseif self.mode == ChooserData.mode.mute then
        self.mode = ChooserData.mode.choose
    else
        self.mode = ChooserData.mode.choose
    end
end

function Chooser:__mode_update_knobs()
    -- print(self.mode)
    self.pad:set_side(self.mode_idx, self.mode[ChooserData.access.color])
end
function Chooser:__mode_clear_knobs()
    -- print(self.mode)
    self.pad:set_side(self.mode_idx, Color.off)
end
