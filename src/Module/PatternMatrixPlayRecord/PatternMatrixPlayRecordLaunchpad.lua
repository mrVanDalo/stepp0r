

function PatternMatrixPlayRecord:__init_launchpad()
    self.__top_idx = 5
    self:__create_record_button_listener()
    self:__create_play_observer()
    self:__create_record_observer()
end
function PatternMatrixPlayRecord:__activate_launchpad()
    self.pad:register_top_listener(self.__button_listener)
    self:_refresh_buttons()
    -- is triggerd when the play status changes
    add_notifier(renoise.song().transport.playing_observable, self.__play_observer)
    add_notifier(renoise.song().transport.edit_mode_observable, self.__record_observer)
end
function PatternMatrixPlayRecord:__deactivate_launchpad()
    remove_notifier(renoise.song().transport.playing_observable, self.__play_observer)
    remove_notifier(renoise.song().transport.edit_mode_observable, self.__record_observer)
    self:__clear_button()
    self.pad:unregister_side_listener(self.__button_listener)
end

function PatternMatrixPlayRecord:__create_play_observer()
    self.__play_observer = function (_)
        if self.is_not_active then return end
        self:_refresh_buttons()
    end
end
function PatternMatrixPlayRecord:__create_record_observer()
    self.__record_observer = function (_)
        if self.is_not_active then return end
        self:_refresh_buttons()
    end
end

function PatternMatrixPlayRecord:__create_record_button_listener()
    self.__button_listener = function (_,msg)
        if self.is_not_active then return end
        if msg.vel ~= Velocity.release then return end
        if msg.x == self.__top_idx then
            self:_toggle_mode()
            self:_refresh_buttons()
        end
    end
end

function PatternMatrixPlayRecord:_toggle_mode()
    if Renoise.transport:is_playing() and Renoise.transport:is_recording() then
        Renoise.transport:stop_playing()
        Renoise.transport:stop_recording()
    elseif Renoise.transport:is_playing() then
        Renoise.transport:start_recording()
    else
        Renoise.transport:start_playing()
        Renoise.transport:stop_recording()
    end
end

function PatternMatrixPlayRecord:_refresh_buttons()
    -- todo : optimize me
    if Renoise.transport:is_recording() and Renoise.transport:is_playing() then
        self.pad:set_top(self.__top_idx, self.color.recording)
    elseif Renoise.transport:is_playing() then
        self:__clear_button()
        self.pad:set_top(self.__top_idx, self.color.playing)
    else
        self.pad:set_top(self.__top_idx, self.color.not_playing)
    end
end

function PatternMatrixPlayRecord:__clear_button()
    self.pad:set_top(self.__top_idx, Color.off)
end
