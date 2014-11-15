
function Chooser:__create_instrument_listener()
    self.instrument_listener = function (_,msg)
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
    end
end

function Chooser:__create_instrumnets_notifier_row()
    self.instruments_notifier_row = function (_)
        self:row_update()
    end
end

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
