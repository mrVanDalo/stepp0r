--- ======================================================================================================
---
---                                                 [ ZOOM ]

function Paginator:__create_zoom_listener()
    self.zoom_listener = function (_,msg)
        if self.is_not_active            then return end
        if msg.vel == Velocity.release   then return end
        if (msg.x == self.zoom_in_idx ) then
            -- todo optimize me, if nothing changed than don't trigger updates
            self:_zoom_in()
            self:_after_zoom_change()
        elseif msg.x == self.zoom_out_idx then
            -- todo optimize me, if nothing changed than don't trigger updates
            self:_zoom_out()
            self:_after_zoom_change()
        end
    end
end

function Paginator:_after_zoom_change()
    self:_page_update_knobs()
    self:_zoom_update_knobs()
    self:_update_listeners()
end

function Paginator:_zoom_out()
    local pattern = self:_active_pattern()
    if (self.zoom < pattern.number_of_lines / 32) then
        -- update zoom
        self.zoom = self.zoom * 2
        -- update page
        self.page = (self.page * 2 ) - 1
        self:_page_update_borders()
        -- correction
--        print("number of lines : " .. pattern.number_of_lines)
--        print("self.page_start : " .. self.page_start)
        if (self.page_start >= pattern.number_of_lines) then
--            print("lower half correction")
            self.page = self.page - 2
            self:_page_update_borders()
        end
        while (self.page_start >= pattern.number_of_lines and self.page > 0) do
--            print("last page correction")
            self.page = self.page - 1
            self:_page_update_borders()
        end
    end
end

function Paginator:_zoom_in()
    if (self.zoom > 1) then
        -- update zoom
        self.zoom = self.zoom / 2
        -- update page
        if (self.page > 1) then
            self.page = math.floor(self.page / 2)
        end
        self:_page_update_borders()
    end
end

function Paginator:_zoom_update_knobs()
    if (self.zoom > 1) then
        self.pad:set_top(self.zoom_in_idx,self.color.zoom.active)
    else
        self.pad:set_top(self.zoom_in_idx,self.color.zoom.inactive)
    end
    local pattern = self:_active_pattern()
    if (self.zoom < (pattern.number_of_lines / 32)) then
        self.pad:set_top(self.zoom_out_idx,self.color.zoom.active)
    else
        self.pad:set_top(self.zoom_out_idx,self.color.zoom.inactive)
    end
end

function Paginator:_zoom_clear_knobs()
    self.pad:set_top(self.zoom_in_idx,Color.off)
    self.pad:set_top(self.zoom_out_idx,Color.off)
end

