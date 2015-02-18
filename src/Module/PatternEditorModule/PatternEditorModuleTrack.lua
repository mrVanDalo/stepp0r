

function PatternEditorModule:__init_track()
    self.track_idx        = 1
    self.instrument_idx   = 1
    self.track_column_idx = 1 -- the column in the track
    self:__create_callback_set_instrument()
end

function PatternEditorModule:__create_callback_set_instrument()
    self.callback_set_instrument =  function (instrument_idx, track_idx, column_idx)
        self.track_idx        = track_idx
        self.track_column_idx = column_idx
        self.instrument_idx   = instrument_idx
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end

