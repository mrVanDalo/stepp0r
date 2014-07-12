--
-- User: palo
-- Date: 7/4/14
--

require 'Data/Color'

-- A class to choose the Instruments
class "Chooser" (LaunchpadModule)

-- register callback that gets a `index of instrument`
function Chooser:register_select_instrument(callback)
    table.insert(self.callback_select_instrument, callback)
end

function Chooser:wire_launchpad(pad)
    self.pad = pad
end

function Chooser:__init()
    LaunchpadModule:__init(self)
    self.active        = 1  -- active instrument index
    self.active_column = 1
    self.row         = 6
    self.color = {
        active  = color.flash.green,
        passive = color.green,
        page = {
            active   = color.yellow,
            inactive = color.off,
        }
    }
    -- page
    self.page         = 1
    self.page_inc_idx = 4
    self.page_dec_idx = 3
    self.inst_offset  = 0  -- which is the first instrument
    -- callbacks
    self.callback_select_instrument = {}
end

function Chooser:_activate()

    -- chooser line
    local function matrix_listener(_,msg)
        if msg.vel == 0x00    then return end
        if msg.y  ~= self.row then return end
        self:select_instrument(msg.x)
        self:update_row()
    end
    self.pad:register_matrix_listener(matrix_listener)
    renoise.song().instruments_observable:add_notifier(function (_)
        self:update_row()
    end)
    self:update_row()

    -- page logic
    local function page_knobs_listener(_,msg)
        if (msg.vel == 0) then return end
        if (msg.x == self.page_inc_idx) then
            self:page_inc()
            self:page_update_knobs()
            self:update_row()
        elseif (msg.x == self.page_dec_idx) then
            self:page_dec()
            self:page_update_knobs()
            self:update_row()
        end
    end
    self.pad:register_top_listener(page_knobs_listener)
    renoise.song().instruments_observable:add_notifier(function (_)
        self:page_update_knobs()
    end)
    self:page_update_knobs()
end

function Chooser:select_instrument(x)
    local active = self.inst_offset + x
    local found = renoise.song().instruments[active]
    if not found        then return  end
    if found.name == "" then return  end
    self.active        = active
    self.active_column = 1
    -- ensure track exist
    local nr_of_tracks = renoise.song().sequencer_track_count
    if (nr_of_tracks < self.active) then
        -- create tracks to that point
        local how_many_to_add = self.active -  nr_of_tracks
        for _ = 1, how_many_to_add do
            renoise.song():insert_track_at(nr_of_tracks + 1)
        end
    end
    -- ensure column exist
    -- find out the number of note_columns that exist
    -- todo : write this part
    -- local pattern_index = renoise.song().selected_pattern_index
    -- local iterator = renoise.song().pattern_iterator:note_columns_in_track(self.active,true)
    -- local iterator = renoise.song().pattern_iterator:note_columns_in_pattern_track(pattern_index, self.active,true)
    -- for pos,column in iterator do
        -- print(pos,column)
    -- end
    --
    -- trigger callbacks
    for _, callback in ipairs(self.callback_select_instrument) do
        callback(self.active,self.active_column)
    end
end

function Chooser:top_callback()
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

function Chooser:update_row()
    self:clear_row()
    for nr, instrument in ipairs(renoise.song().instruments) do
        if nr - self.inst_offset > 8 then
            break
        end
        if instrument.name ~= "" then
            print(nr, instrument.name)
            if nr == self.active then
                self.pad:set_matrix(nr - self.inst_offset, self.row, self.color.active)
            else
                self.pad:set_matrix(nr - self.inst_offset, self.row, self.color.passive)
            end
        end
    end
end

function Chooser:clear_row()
    for x = 1, 8, 1 do
        self.pad:set_matrix(x,self.row,self.pad.color.off)
    end
end

function Chooser:_deactivate()
    self:clear_row()
end
