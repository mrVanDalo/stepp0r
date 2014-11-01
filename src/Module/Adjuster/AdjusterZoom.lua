--- ======================================================================================================
---
---                                                 [ ZOOM ]

function Adjuster:zoom_out()
    local pattern = self:active_pattern()
    if (self.zoom < pattern.number_of_lines / 32) then
        -- update zoom
        self.zoom = self.zoom * 2
        -- update page
        self.page = (self.page * 2 ) - 1
        self:page_update_borders()
        -- correction
        if (self.page_start >= pattern.number_of_lines) then
            self.page = self.page - 2
            self:page_update_borders()
        end
        -- refresh page
        self:_refresh_matrix()
    end
    self:_page_update_knobs()
    self:_zoom_update_knobs()
end

function Adjuster:zoom_in()
    if (self.zoom > 1) then
        -- update zoom
        self.zoom = self.zoom / 2
        -- update page
        if (self.page > 1) then
            self.page = math.floor(self.page / 2)
        end
        self:page_update_borders()
        -- refresh martix
        self:_refresh_matrix()
    end
    self:_page_update_knobs()
    self:_zoom_update_knobs()
end

function Adjuster:_zoom_update_knobs()
    if (self.zoom > 1) then
        self.pad:set_top(self.zoom_in_idx,self.color.zoom.active)
    else
        self.pad:set_top(self.zoom_in_idx,self.color.zoom.inactive)
    end
    local pattern = self:active_pattern()
    if (self.zoom < (pattern.number_of_lines / 32)) then
        self.pad:set_top(self.zoom_out_idx,self.color.zoom.active)
    else
        self.pad:set_top(self.zoom_out_idx,self.color.zoom.inactive)
    end
end

function Adjuster:_zoom_clear_knobs()
    self.pad:set_top(self.zoom_in_idx,Color.off)
    self.pad:set_top(self.zoom_out_idx,Color.off)
end
