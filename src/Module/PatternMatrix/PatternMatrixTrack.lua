

function PatternMatrix:__init_track()
    self.__track_idx = 1 -- selected track
    self:__create_it_selection_listerner()
end

function PatternMatrix:__activate_track()

end

function PatternMatrix:__deactivate_track()

end



function PatternMatrix:__create_it_selection_listerner()
    self.callback_set_instrument = function (instrument_idx, track_idx, column_idx)
        self.__track_idx = track_idx
        print("update track idx ", self.__track_idx)
        if self.is_not_active then return end
        self:_refresh_matrix()
    end
end

