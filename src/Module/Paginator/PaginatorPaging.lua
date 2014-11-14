--- ======================================================================================================
---
---                                                 [ Pagination ]

function Paginator:__create_page_listener()
    self.page_listener = function (_,msg)
        if self.is_not_active            then return end
        if msg.vel == Velocity.release   then return end
        if msg.x == self.page_inc_idx then
            self:_page_inc()
        elseif msg.x == self.page_dec_idx then
            self:_page_dec()
        end
        self:_page_update_knobs()
        self:_page_update_borders()
        self:_update_listeners()
    end
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


function Paginator:_page_update_knobs()
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

function Paginator:_page_clear_knobs()
    self.pad:set_top(self.page_dec_idx,Color.off)
    self.pad:set_top(self.page_inc_idx,Color.off)
end

function Paginator:_page_update_borders()
    self.page_start = ((self.page - 1) * 32 * self.zoom)
    self.page_end   = self.page_start + 1 + 32 * self.zoom
    -- print("update page borders", self.page, self.page_start, self.page_end)
end

