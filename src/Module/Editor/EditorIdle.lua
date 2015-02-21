
function Editor:__init_idle()
    self:__create_idle_callback()
end
function Editor:__activate_idle()
end
function Editor:__deactivate_idle()
end

function Editor:__create_idle_callback()
    self.idle_callback = function ()
        if self.is_not_active then return end
        self:_refresh_matrix()
    end
end
