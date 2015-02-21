

function Adjuster:__init_idle()
    self:__create_idle_callback()
end
function Adjuster:__activate_idle()
end
function Adjuster:__deactivate_idle()
end

function Adjuster:__create_idle_callback()
    self.idle_callback = function ()
        if self.is_not_active then return end
        self:_refresh_matrix()
    end
end
