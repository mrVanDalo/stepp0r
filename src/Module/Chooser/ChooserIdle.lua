function Chooser:__init_idle()
    self:__create_idle_callback()
end

function Chooser:__activate_idle()
end

function Chooser:__deactivate_idle()
end

function Chooser:__create_idle_callback()
    self.idle_callback = function ()
        if self.is_not_active then return end
        self:_update_instrument_row()
    end
end
