

function IT_Selection:_init_column()
    self.column_idx     = 1
end


--- ======================================================================================================
---
---                                                 [ lib ]

function IT_Selection:ensure_column_idx_exists()
    local track = self:track_for_instrument(self.instrument_idx)
    if track.visible_note_columns < self.column_idx then
        track.visible_note_columns = self.column_idx
    end
end

function IT_Selection:set_column(column_idx)
    self.column_idx = column_idx
    self:ensure_column_idx_exists()
    self:__update_set_instrument_listeners()
end





