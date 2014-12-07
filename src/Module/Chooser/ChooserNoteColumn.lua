function Chooser:__create_column_update()
    self._column_listener = function (_,msg)
        if self.is_not_active            then return end
        if msg.vel == Velocity.release   then return end
        if msg.x > self.column_idx_stop  then return end
        if msg.x < self.column_idx_start then return end

        -- self.column_idx = msg.x
        self.it_selection:set_column(msg.x)
--        self.it_selection:ensure_column_idx_exists()
        self:column_update_knobs()
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
        self.pad:set_side(i,color)
    end
end

function Chooser:column_clear_knobs()
    for i = self.column_idx_start, self.column_idx_stop do
        self.pad:set_side(i,Color.off)
    end
end
