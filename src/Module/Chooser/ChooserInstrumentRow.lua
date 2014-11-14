
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