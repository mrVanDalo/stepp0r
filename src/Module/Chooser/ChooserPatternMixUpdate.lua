function Chooser:__init_pattern_mix_update()
    self:__create_pattern_mix_update_callback()
end

function Chooser:__activate_pattern_mix_update()
end

function Chooser:__deactivate_pattern_mix_update()
end

function Chooser:__create_pattern_mix_update_callback()
    self.pattern_mix_update_callback = function (update)
        if self.is_not_active then return end
        self:_update_instrument_row()
    end
end
