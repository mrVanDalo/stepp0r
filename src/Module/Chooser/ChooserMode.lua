
function Chooser:__create_mode_listener()
    self.mode_listener = function (_,msg)
        if self.is_not_active          then return end
        if msg.vel == Velocity.release then return end
        if msg.x   ~= self.mode_idx    then return end
        self:mode_next()
        self:mode_update_knobs()
    end
end