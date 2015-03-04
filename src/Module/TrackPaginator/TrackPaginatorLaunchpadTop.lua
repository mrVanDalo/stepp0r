--- ======================================================================================================
---
---                                                 [ PAGINATION ]

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]
function TrackPaginator:__init_launchpad_top()
    self.__page_inc_idx = 4
    self.__page_dec_idx = 3
    self:__create_page_listener()
end
function TrackPaginator:__activate_launchpad_top()
    self:__update_page_knobs()
    self.pad:register_top_listener(self.page_listener)
end
function TrackPaginator:__deactivate_launchpad_top()
    self:__clear_page_knobs()
    self.pad:unregister_top_listener(self.page_listener)
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function TrackPaginator:wire_launchpad(pad)
    self.pad = pad
end


function TrackPaginator:__create_page_listener()
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

function TrackPaginator:__update_page_knobs()
    self.pad:set_top(self.__page_inc_idx, self.color.page.active)
    if self._page_offset == 0 then
        self.pad:set_top(self.__page_dec_idx, self.color.page.inactive)
    else
        self.pad:set_top(self.__page_dec_idx, self.color.page.active)
    end
end

function TrackPaginator:__clear_page_knobs()
    self.pad:set_top(self.__page_dec_idx,Color.off)
    self.pad:set_top(self.__page_inc_idx,Color.off)
end


