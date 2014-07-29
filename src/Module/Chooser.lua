--
-- User: palo
-- Date: 7/4/14
--

require 'Data/Color'
require 'Module/Module'

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
    self.active        = 1  -- active instrument index and track index
    self.row           = 6
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
            active   = Color.yellow,
            inactive = Color.off,
        },
    }
    -- page
    self.page         = 1
    self.page_inc_idx = 4
    self.page_dec_idx = 3
    -- instruments
    self.inst_offset  = 0  -- which is the first instrument
    -- column
    self.column_idx       = 1 -- number of the column
    self.column_idx_start = 1
    self.column_idx_stop  = 4
    -- callbacks
    self.callback_select_instrument = {}
end

function Chooser:wire_launchpad(pad)
    self.pad = pad
end

--- register callback
--
-- the callback gets the `index of instrument` and `the active note column`
function Chooser:register_select_instrument(callback)
    table.insert(self.callback_select_instrument, callback)
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
                self:select_instrument(msg.x)
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
            self:ensure_column_idx_exists()
            self:column_update_knobs()
            self:update_set_instrument_listeners()
        end)
    end
end

function Chooser:_deactivate()
    self:row_clear()
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

function Chooser:mute_track(x)
    local active = self.inst_offset + x
    self:ensure_active_track_exist()
    local track = renoise.song().tracks[active]
    if track then
        if track.type == renoise.Track.TRACK_TYPE_SEQUENCER then
            if track.mute_state == renoise.Track.MUTE_STATE_ACTIVE then
                track:mute()
            else
                track:unmute()
            end
        end
    end
end

function Chooser:ensure_active_track_exist()
    local nr_of_tracks = renoise.song().sequencer_track_count
    if (nr_of_tracks < self.active) then
        -- create tracks to that point
        local how_many_to_add = self.active -  nr_of_tracks
        for _ = 1, how_many_to_add do
            renoise.song():insert_track_at(nr_of_tracks + 1)
        end
    end
end

function Chooser:ensure_column_idx_exists()
    local track = renoise.song().tracks[self.active]
    -- ensure column exist
    if track.visible_note_columns < self.column_idx then
        print("update note_columns")
        track.visible_note_columns = self.column_idx
    else
        print("dont update note_columns")
    end
end

function Chooser:select_instrument(x)
    local active = self.inst_offset + x
    local found = renoise.song().instruments[active]
    if not found        then return  end
    if found.name == "" then return  end
    self.active     = active
    self.column_idx = 1
    -- ensure track exist
    self:ensure_active_track_exist()
    -- rename track
    renoise.song().tracks[self.active].name = found.name
    -- trigger callbacks
    self:update_set_instrument_listeners()
end

function Chooser:update_set_instrument_listeners()
    for _, callback in ipairs(self.callback_select_instrument) do
        callback(self.active,self.column_idx)
    end
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
        if nr - self.inst_offset > 8 then
            break
        end
        if instrument.name ~= "" then
            -- print(nr, instrument.name)
            local active_color  = self.color.instrument.active
            local passive_color = self.color.instrument.passive
            local track = renoise.song().tracks[nr]
            if track then
                if track.mute_state == renoise.Track.MUTE_STATE_OFF  or  track.mute_state == renoise.Track.MUTE_STATE_MUTED
                then
                    active_color  = self.color.mute.active
                    passive_color = self.color.mute.passive
                end
            end
            if nr == self.active then
                self.pad:set_matrix(nr - self.inst_offset, self.row, active_color)
            else
                self.pad:set_matrix(nr - self.inst_offset, self.row, passive_color)
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
    for i = self.column_idx_start, self.column_idx_stop do
        local color = self.color.column.inactive
        if i == self.column_idx then
            color = self.color.column.active
        end
        self.pad:set_right(i,color)
    end
end

