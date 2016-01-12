

function PatternMatrix:__init_it_selection()
    self.__track_idx = 1 -- selected track
    self:__create_it_selection_listerner()
    self:__create_it_selection_idle_listener()

    self.it_selection = nil
end

function PatternMatrix:__activate_it_selection()

end

function PatternMatrix:__deactivate_it_selection()

end

function PatternMatrix:wire_it_selection(it_selection)
    self.it_selection = it_selection
end

function PatternMatrix:__create_it_selection_listerner()
    self.callback_set_instrument = function (instrument_idx, track_idx, column_idx)
        self.__track_idx = track_idx
--        print("pattern matrix : update track idx ", self.__track_idx)
        if self.is_not_active then return end
        self:_refresh_matrix()
    end
end

function PatternMatrix:__create_it_selection_idle_listener()
    self.idle_callback = function ()
        if self.is_not_active then return end
--        print("pattern matrix : update instrument selection")
        if not self.it_selection:sync_track_with_instrument() then return  end
        self:_refresh_matrix()
    end
end
