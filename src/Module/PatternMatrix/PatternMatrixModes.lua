

function PatternMatrix:__init_modes()
    self.mode = PatternMatrixData.mode.mix
    self.mode_knob_idx = 7
    self:__create_mode_knobs_listener()
end
function PatternMatrix:__activate_modes()
    self.pad:register_top_listener(self.__mode_knobs_listener)
    self:__render_mode_knobs()
end
function PatternMatrix:__deactivate_modes()
    self.pad:unregister_top_listener(self.__mode_knobs_listener)
end

function PatternMatrix:__create_mode_knobs_listener()
    self.__mode_knobs_listener = function (_, msg)
        if self.is_not_active          then return end
        if msg.vel ~= Velocity.release then return end
        if msg.x ~= self.mode_knob_idx then return end
        self:__toggle_mode()
        self:__render_mode_knobs()
    end
end

function PatternMatrix:__toggle_mode()
    if self.mode == PatternMatrixData.mode.mix then
        self.mode = PatternMatrixData.mode.clear
    elseif self.mode == PatternMatrixData.mode.clear then
        self.mode = PatternMatrixData.mode.copy
    else
        self.mode = PatternMatrixData.mode.mix
    end
    self:_render_row()
end

function PatternMatrix:__render_mode_knobs()
    if self.mode == PatternMatrixData.mode.mix then
        self.pad:set_top(self.mode_knob_idx, self.mode_color.mix)
    elseif self.mode == PatternMatrixData.mode.clear then
        self.pad:set_top(self.mode_knob_idx, self.mode_color.clear)
    else
        self.pad:set_top(self.mode_knob_idx, Color.off)
        self.pad:set_top(self.mode_knob_idx, self.mode_color.copy)
    end
end
