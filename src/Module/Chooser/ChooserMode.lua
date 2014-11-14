

--- ======================================================================================================
---
---                                                 [ Mode Control ]

function Chooser:__create_mode_listener()
    self.mode_listener = function (_,msg)
        if self.is_not_active          then return end
        if msg.vel == Velocity.release then return end
        if msg.x   ~= self.mode_idx    then return end
        self:mode_next()
        self:mode_update_knobs()
    end
end

function Chooser:mode_next()
    if self.mode == ChooserData.mode.choose then
        self.mode = ChooserData.mode.mute
    elseif self.mode == ChooserData.mode.mute then
        self.mode = ChooserData.mode.choose
    else
        self.mode = ChooserData.mode.choose
    end
end

function Chooser:mode_update_knobs()
    -- print(self.mode)
    self.pad:set_right(self.mode_idx, self.mode[ChooserData.access.color])
end
function Chooser:mode_clear_knobs()
    -- print(self.mode)
    self.pad:set_right(self.mode_idx, Color.off)
end
