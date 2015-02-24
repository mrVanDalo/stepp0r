--- ======================================================================================================
---
---                                                 [ Paginator ]
---
--- paginator for pattern editing (not for pattern matrix)


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Paginator:__init_paging()
    self.page         = 1 -- page of actual pattern
    self.page_inc_idx = 2
    self.page_dec_idx = 1
    self.page_start   = 0  -- line left before first pixel
    self.page_end     = 33 -- line right after last pixel
    self:__create_page_listener()
end
function Paginator:__activate_paging()
    self.pad:register_top_listener(self.page_listener)
    self:_update_page_knobs()
end
function Paginator:__deactivate_paging()
    self.pad:unregister_top_listener(self.page_listener)
    self:__clear_page_knobs()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Paginator:__create_page_listener()
    self.page_listener = function (_,msg)
        if self.is_not_active            then return end
        if msg.vel == Velocity.release   then return end
        if msg.x == self.page_inc_idx then
            self:_page_inc()
            self:_after_page_change()
        elseif msg.x == self.page_dec_idx then
            self:_page_dec()
            self:_after_page_change()
        end
    end
end

function Paginator:_after_page_change()
    self:_update_page_borders()
    self:_update_page_knobs()
    self:_update_listeners()
end

function Paginator:_page_inc()
    local pattern = self:_active_pattern()
    if (self.page_end >= pattern.number_of_lines) then return end
    self.page = self.page + 1
end

function Paginator:_page_dec()
    if(self.page_start <= 0 ) then return end
    self.page = self.page - 1
end


function Paginator:_update_page_knobs()
    if (self.page_start <= 0)  then
        self.pad:set_top(self.page_dec_idx,self.color.page.inactive)
    else
        self.pad:set_top(self.page_dec_idx,self.color.page.active)
    end
    local pattern = self:_active_pattern()
    if (self.page_end >= pattern.number_of_lines)  then
        self.pad:set_top(self.page_inc_idx,self.color.page.inactive)
    else
        self.pad:set_top(self.page_inc_idx,self.color.page.active)
    end
end

function Paginator:__clear_page_knobs()
    self.pad:set_top(self.page_dec_idx,Color.off)
    self.pad:set_top(self.page_inc_idx,Color.off)
end

function Paginator:_update_page_borders()
    self.page_start = ((self.page - 1) * 32 * self.zoom)
    self.page_end   = self.page_start + 1 + 32 * self.zoom
end

