--- ======================================================================================================
---
---                                                 [ PAGINATION ]

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]
function Chooser:__init_pagination()
end
function Chooser:__activate_pagination()
end
function Chooser:__deactivate_pagination()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Chooser:__create_page_listener()
    self.page_listener = function (_,msg)
        if self.is_not_active         then return end
        if msg.vel == 0               then return end
        if msg.x == self.page_inc_idx then
            self:page_inc()
            self:page_update_knobs()
            self:row_update()
        elseif msg.x == self.page_dec_idx then
            self:page_dec()
            self:page_update_knobs()
            self:row_update()
        end
    end
end

function Chooser:__create_instrument_notifier()
    self.instruments_notifier = function (_)
        if self.is_not_active then return end
        self:page_update_knobs()
    end
end

function Chooser:page_update_knobs()
    local instrument_count = table.getn(renoise.song().instruments)
    if (self.inst_offset + 8 ) < instrument_count then
        self.pad:set_top(self.page_inc_idx, self.color.page.active)
    else
        self.pad:set_top(self.page_inc_idx, self.color.page.inactive)
    end
    if self.inst_offset >  7 then
        self.pad:set_top(self.page_dec_idx, self.color.page.active)
    else
        self.pad:set_top(self.page_dec_idx, self.color.page.inactive)
    end
end

function Chooser:page_clear_knobs()
    self.pad:set_top(self.page_dec_idx,Color.off)
    self.pad:set_top(self.page_inc_idx,Color.off)
end

function Chooser:page_inc()
    local instrument_count = table.getn(renoise.song().instruments)
    if (self.inst_offset + 8) < instrument_count then
        self.inst_offset = self.inst_offset + 8
    end
end

function Chooser:page_dec()
    if( self.inst_offset > 0 ) then
        self.inst_offset = self.inst_offset - 8
    end
end

