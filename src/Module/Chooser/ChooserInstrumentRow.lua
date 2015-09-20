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
        if self.is_not_active then return end
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
        if self.is_not_active then return end
        self:_update_instrument_row()
    end
end

function Chooser:_update_instrument_row()
    self:__clear_instrument_row()
    self.it_selection:sync_track_with_instrument()
    for nr, instrument in ipairs(Renoise.instrument:list()) do
        local scaled_index = nr - self.inst_offset
        if scaled_index > 8 then break end
        if Renoise.instrument:exist(instrument) and scaled_index > 0 then
            -- mute state
            local mute_state = ChooserData.color.unmute
--            local track = self.it_selection:track_for_instrument(nr)
            local track = Renoise.sequence_track:track(nr)
            if track and (track.mute_state == TrackData.mute.off or track.mute_state == TrackData.mute.muted)  then
                mute_state = ChooserData.color.mute
            end
            -- active state
            local active_state = ChooserData.color.inactive
            if nr == self.instrument_idx then
                active_state = ChooserData.color.active
            end
            -- group
            local group_state = ChooserData.color.group_a
            local group_idx = Renoise.sequence_track:group_type_2(nr)
            if group_idx == 0 then
                group_state = ChooserData.color.group_b
            end
            -- draw
            self.pad:set_matrix(scaled_index, self.row, self.color.instrument[ mute_state + active_state + group_state ] )
        end
    end
end

function Chooser:__clear_instrument_row()
    for x = 1, 8, 1 do
        self.pad:set_matrix(x,self.row, ChooserData.color.clear)
    end
end

function Chooser:__mute_track(x)
    self.it_selection:sync_track_with_instrument()
    local active = self.inst_offset + x
    local track = Renoise.sequence_track:track(active)
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
