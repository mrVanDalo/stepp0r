--- ======================================================================================================
---
---                                                   Chooser Moudle
---
--- To choose instruments, tracks and track rows.

ChooserData =  {
    access = {
        id    = 1,
        color = 2,
    },
    mode = {
        choose = {1, Color.yellow},
        mute   = {2, Color.red},
    },
    color = {
        clear = Color.off,
    },
}

-- A class to choose the Instruments
class "Chooser" (Module)





--- ======================================================================================================
---
---                                                 [ INIT ]


function Chooser:__init()
    Module:__init(self)
    self.instrument_idx = 1
    self.track_idx      = 1
    self.row            = 6
    self.mode          = ChooserData.mode.choose
    self.mode_idx      = self.row
    self.color = {
        instrument = {
            active  = Color.flash.green,
            passive = Color.green,
        },
        mute = {
            active  = Color.flash.red,
            passive = Color.red,
        },
        page = {
            active   = Color.yellow,
            inactive = Color.off,
        },
        column = {
            active    = Color.yellow,
            inactive  = Color.dim.green,
            invisible = Color.off,
        },
    }
    -- page
    self.page         = 1
    self.page_inc_idx = 4
    self.page_dec_idx = 3
    -- instruments
    self.inst_offset  = 0  -- which is the first instrument
    -- column
    self.column_idx       = 1 -- index of the column
    self.column_idx_start = 1
    self.column_idx_stop  = 4
    -- callbacks
    self.callback_select_instrument = {}
end

function Chooser:wire_launchpad(pad)
    self.pad = pad
end

function Chooser:wire_it_selection(selection)
    self.it_selection = selection
end




--- ======================================================================================================
---
---                                                 [ boot ]

function Chooser:_activate()

    --- chooser line
    self:row_update()
    if self.is_first_run then
        self.pad:register_matrix_listener(function (_,msg)
            if self.is_not_active          then return end
            if msg.vel == Velocity.release then return end
            if msg.y  ~= self.row          then return end
            if self.mode == ChooserData.mode.choose then
                self:select_instrument_with_offset(msg.x)
            elseif self.mode == ChooserData.mode.mute then
                self:mute_track(msg.x)
            end
            self:column_update_knobs()
            self:row_update()
        end)
        renoise.song().instruments_observable:add_notifier(function (_)
            self:row_update()
        end)
    end

    --- mode control
    self:mode_update_knobs()
    if self.is_first_run then
        self.pad:register_right_listener(function (_,msg)
            if self.is_not_active          then return end
            if msg.vel == Velocity.release then return end
            if msg.x   ~= self.mode_idx    then return end
            self:mode_next()
            self:mode_update_knobs()
        end)
    end

    --- page logic
    self:page_update_knobs()
    if self.is_first_run then
        self.pad:register_top_listener(function (_,msg)
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
        end)
        renoise.song().instruments_observable:add_notifier(function (_)
            if self.is_not_active then return end
            self:page_update_knobs()
        end)
    end

    --- column logic
    self:column_update_knobs()
    if self.is_first_run then
        self.pad:register_right_listener(function (_,msg)
            if self.is_not_active            then return end
            if msg.vel == Velocity.release   then return end
            if msg.x > self.column_idx_stop  then return end
            if msg.x < self.column_idx_start then return end

            self.column_idx = msg.x
            self.it_selection:ensure_column_idx_exists()
            self:column_update_knobs()
        end)
    end

end

function Chooser:_deactivate()
    self:column_clear_knobs()
    self:page_clear_knobs()
    self:mode_clear_knobs()
    self:row_clear()
end


function Chooser:callback_set_instrument()
    return function(instrument_idx, track_idx, column_idx)
        self.instrument_idx = instrument_idx
        self.track_idx      = track_idx
        self.column_idx     = column_idx
        self:row_update()
        self:column_update_knobs()
        self:page_update_knobs()
    end
end





--- ======================================================================================================
---
---                                                 [ Mode Control ]


function Chooser:mode_next()
    if self.mode == ChooserData.mode.choose then
        self.mode = ChooserData.mode.mute
    elseif self.mode == ChooserData.mode.mute then
        self.mode = ChooserData.mode.choose
    else
        self.mode = ChooserData.mode.choose
    end
end

function Chooser:mode_update_knobs()
    -- print(self.mode)
    self.pad:set_right(self.mode_idx, self.mode[ChooserData.access.color])
end
function Chooser:mode_clear_knobs()
    -- print(self.mode)
    self.pad:set_right(self.mode_idx, Color.off)
end

function Chooser:mute_track(x)
    local active = self.inst_offset + x
    local track = self.it_selection:track_for_instrument(active)
    if track then
        if track.mute_state == TrackData.mute.active then
            track:mute()
        else
            track:unmute()
        end
    end
end


function Chooser:select_instrument_with_offset(x)
    local active = self.inst_offset + x
    self.it_selection:select_instrument(active)
end


--- ======================================================================================================
---
---                                                 [ PAGINATION ]

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





--- ======================================================================================================
---
---                                                 [ RENDERING ]

function Chooser:row_update()
    -- todo using the mute state too
    self:row_clear()
    for nr, instrument in ipairs(renoise.song().instruments) do
        local scaled_index = nr - self.inst_offset
        if scaled_index > 8 then break end
        if self.it_selection:instrument_exists_p(instrument) and scaled_index > 0 then
            local active_color  = self.color.instrument.active
            local passive_color = self.color.instrument.passive
            -- todo speed me up, by a specific function for this case
            local track = self.it_selection:track_for_instrument(nr)
            if track then
                if track.mute_state == TrackData.mute.off or track.mute_state == TrackData.mute.muted
                then
                    active_color  = self.color.mute.active
                    passive_color = self.color.mute.passive
                end
            end
            if nr == self.instrument_idx then
                self.pad:set_matrix(scaled_index, self.row, active_color)
            else
                self.pad:set_matrix(scaled_index, self.row, passive_color)
            end
        end
    end
end

function Chooser:row_clear()
    for x = 1, 8, 1 do
        self.pad:set_matrix(x,self.row, ChooserData.color.clear)
    end
end



function Chooser:column_update_knobs()
    -- todo us the constante here ?
    local track = self.it_selection:track_for_instrument(self.instrument_idx)
    local visible = track.visible_note_columns + self.column_idx_start
    for i = self.column_idx_start, self.column_idx_stop do
        local color = self.color.column.invisible
        if i == self.column_idx then
            color = self.color.column.active
        elseif i < visible then
            color = self.color.column.inactive
        end
        self.pad:set_right(i,color)
    end
end

function Chooser:column_clear_knobs()
    for i = self.column_idx_start, self.column_idx_stop do
        self.pad:set_right(i,Color.off)
    end
end

