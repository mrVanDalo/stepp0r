

function IT_Selection:_init_column()
    self.column_idx     = 1
end


--- ======================================================================================================
---
---                                                 [ lib ]

-- todo : make this faster
function IT_Selection:ensure_column_idx_exists()
    self:sync_track_with_instrument()
    local track = Renoise.sequence_track:track(self.instrument_idx)
    if track.visible_note_columns < self.column_idx then
        track.visible_note_columns = self.column_idx
    end
end

function IT_Selection:set_column(column_idx)
    self.column_idx = column_idx
    self:ensure_column_idx_exists()
    self:__update_set_instrument_listeners()
end





