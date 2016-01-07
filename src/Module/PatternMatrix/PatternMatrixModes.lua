

function PatternMatrix:__init_modes()
    self.mode = PatternMatrixData.mode.mix
--    self.mode_knob_idx = 7
    self.copy_mode_knob_idx = 5
    self.clear_mode_knob_idx = 6
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
        -- copy
        if msg.x == self.copy_mode_knob_idx and
                msg.vel ~= Velocity.release then
            --            print("set copy mode")
            self.mode = PatternMatrixData.mode.copy
        end
        if msg.x == self.copy_mode_knob_idx and
                msg.vel == Velocity.release then
            --            print("unset copy mode")
            self.mode = PatternMatrixData.mode.mix
        end
        -- clear
        if msg.x == self.clear_mode_knob_idx and
                msg.vel ~= Velocity.release then
            --            print("set clear mode")
            self.mode = PatternMatrixData.mode.clear
        end
        if msg.x == self.clear_mode_knob_idx and
                msg.vel == Velocity.release then
            --            print("unset clear mode")
            self.mode = PatternMatrixData.mode.mix
        end
        self:_render_row()
    end
end

function PatternMatrix:__render_mode_knobs()
    self.pad:set_top(self.copy_mode_knob_idx, self.mode_color.copy)
    self.pad:set_top(self.clear_mode_knob_idx, self.mode_color.clear)
end
