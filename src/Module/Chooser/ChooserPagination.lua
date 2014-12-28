--- ======================================================================================================
---
---                                                 [ PAGINATION ]

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]
function Chooser:__init_pagination()
    self.page         = 1
    self.page_inc_idx = 4
    self.page_dec_idx = 3
    self:__create_page_listener()
    self:__create_instruments_page_notifier()
end
function Chooser:__activate_pagination()
    self:_update_page_knobs()
    self.pad:register_top_listener(self.page_listener)
    add_notifier(renoise.song().instruments_observable, self.instruments_page_notifier)
end
function Chooser:__deactivate_pagination()
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
        if msg.x == self.page_inc_idx then
            self:__page_inc()
            self:_update_page_knobs()
            self:_update_instrument_row()
        elseif msg.x == self.page_dec_idx then
            self:__page_dec()
            self:_update_page_knobs()
            self:_update_instrument_row()
        end
    end
end

--- notifier for instrument changes
--
-- there is also another notifier wired to the same event for updating the instruments row
function Chooser:__create_instruments_page_notifier()
    self.instruments_page_notifier = function (_)
        if self.is_not_active then return end
        self:_update_page_knobs()
    end
end

function Chooser:_update_page_knobs()
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

function Chooser:__clear_page_knobs()
    self.pad:set_top(self.page_dec_idx,Color.off)
    self.pad:set_top(self.page_inc_idx,Color.off)
end

function Chooser:__page_inc()
    local instrument_count = table.getn(renoise.song().instruments)
    if (self.inst_offset + 8) < instrument_count then
        self.inst_offset = self.inst_offset + 8
    end
end

function Chooser:__page_dec()
    if( self.inst_offset > 0 ) then
        self.inst_offset = self.inst_offset - 8
    end
end

