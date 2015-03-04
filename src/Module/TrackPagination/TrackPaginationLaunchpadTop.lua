--- ======================================================================================================
---
---                                                 [ PAGINATION ]

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]
function Chooser:__init_launchpad_top()
    self.__page_inc_idx = 4
    self.__page_dec_idx = 3
    self:__create_page_listener()
end
function Chooser:__activate_launchpad_top()
    self:__update_page_knobs()
    self.pad:register_top_listener(self.page_listener)
    add_notifier(renoise.song().instruments_observable, self.instruments_page_notifier)
end
function Chooser:__deactivate_launchpad_top()
    self:__clear_page_knobs()
    self.pad:unregister_top_listener(self.page_listener)
    remove_notifier(renoise.song().instruments_observable, self.instruments_page_notifier)
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Chooser:__create_page_listener()
    self.page_listener = function (_,msg)
        if self.is_not_active         then return end
        if msg.vel == 0               then return end
        if msg.x == self.__page_inc_idx then
            self:_page_inc()
            self:__update_page_knobs()
            self:_update_callbacks()
        elseif msg.x == self.__page_dec_idx then
            self:_page_dec()
            self:__update_page_knobs()
            self:_update_callbacks()
        end
    end
end

function Chooser:__update_page_knobs()
    self.pad:set_top(self.__page_inc_idx, self.color.page.active)
    if self._page_offset == 0 then
        self.pad:set_top(self.__page_dec_idx, self.color.page.inactive)
    else
        self.pad:set_top(self.__page_dec_idx, self.color.page.active)
    end
end

function Chooser:__clear_page_knobs()
    self.pad:set_top(self.__page_dec_idx,Color.off)
    self.pad:set_top(self.__page_inc_idx,Color.off)
end


