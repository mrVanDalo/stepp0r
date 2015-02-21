--- ======================================================================================================
---
---                                                 [ Instrument Row ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Chooser:__init_instrument_row()
    -- variables
    self.inst_offset    = 0  -- which is the first instrument
    self.instrument_idx = 1
    self.track_idx      = 1
    self.row            = 6
    -- changeable
    self.follow_mute    = nil
    -- callbacks
    self.callback_select_instrument = {}
    -- create functions
    self:__create_callback_set_instrument()
    self:__create_instrument_listener()
    self:__create_instruments_row_notifier()
end
function Chooser:__activate_instrument_row()
    self:_update_instrument_row()
    self.pad:register_matrix_listener(self.instrument_listener)
    add_notifier(renoise.song().instruments_observable, self.instruments_row_notifier)
end
function Chooser:__deactivate_instrument_row()
    self:__clear_instrument_row()
    self.pad:unregister_matrix_listener(self.instrument_listener)
    remove_notifier(renoise.song().instruments_observable, self.instruments_row_notifier)
end

function Chooser:set_follow_mute()
    self.follow_mute = 1
end
function Chooser:unset_follow_mute()
    self.follow_mute = nil
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Chooser:__create_callback_set_instrument()
    self.callback_set_instrument = function(instrument_idx, track_idx, column_idx)
        self.instrument_idx = instrument_idx
        self.track_idx      = track_idx
        self.column_idx     = column_idx
        self:_update_instrument_row()
        self:_update_column_knobs()
        self:_update_page_knobs()
    end
end

function Chooser:__create_instrument_listener()
    self.instrument_listener = function (_,msg)
        if self.is_not_active          then return end
        if msg.vel == Velocity.release then return end
        if msg.y  ~= self.row          then return end
        if self.mode == ChooserData.mode.choose then
            self:__select_instrument_with_offset(msg.x)
        elseif self.mode == ChooserData.mode.mute then
            self:__mute_track(msg.x)
            if (self.follow_mute) then
                self:__select_instrument_with_offset(msg.x)
            end
        end
        self:_update_column_knobs()
        self:_update_instrument_row()
    end
end

--- notifier for instrument changes
--
-- there is also another notifier wired to the same event for updating the page buttons
function Chooser:__create_instruments_row_notifier()
    self.instruments_row_notifier = function (_)
        self:_update_instrument_row()
    end
end

function Chooser:_update_instrument_row()
    self:__clear_instrument_row()
    for nr, instrument in ipairs(renoise.song().instruments) do
        local scaled_index = nr - self.inst_offset
        if scaled_index > 8 then break end
        if self.it_selection:instrument_exists_p(instrument) and scaled_index > 0 then
            local active_color  = self.color.instrument.active
            local passive_color = self.color.instrument.passive
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

function Chooser:__clear_instrument_row()
    for x = 1, 8, 1 do
        self.pad:set_matrix(x,self.row, ChooserData.color.clear)
    end
end

function Chooser:__mute_track(x)
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

function Chooser:__select_instrument_with_offset(x)
    local active = self.inst_offset + x
    self.it_selection:select_instrument(active)
end
