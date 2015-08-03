

function RecordButton:__init_launchpad()
    self.__record_side_idx = 7
    self.__play_side_idx = 8
    self:__create_record_button_listener()
    self:__create_play_observer()
end
function RecordButton:__activate_launchpad()
    self.pad:register_side_listener(self.__button_listener)
    self:_refresh_buttons()
    add_notifier(renoise.song().transport.playing_observable, self.__play_observer)
end
function RecordButton:__deactivate_launchpad()
    remove_notifier(renoise.song().transport.playing_observable, self.__play_observer)
    self:__clear_button()
    self.pad:unregister_side_listener(self.__button_listener)
end

function RecordButton:__create_play_observer()
    self.__play_observer = function (_)
        if self.is_not_active then return end
        self:_refresh_buttons()
    end
end

function RecordButton:__create_record_button_listener()
    self.__button_listener = function (_,msg)
        if self.is_not_active then return end
        if msg.vel ~= Velocity.release then return end
        if msg.x == self.__record_side_idx then
            self:_toggle_record()
            self:_refresh_buttons()
        elseif msg.x == self.__play_side_idx then
            self:_toggle_play()
            self:_refresh_buttons()
        end
    end
end

function RecordButton:_refresh_buttons()
    if Renoise.transport:is_recording() then
        self.pad:set_side(self.__record_side_idx, Color.off)
        self.pad:set_side(self.__record_side_idx, self.color.recording)
    else
        self.pad:set_side(self.__record_side_idx, self.color.not_recording)
    end
    if Renoise.transport:is_playing() then
        self.pad:set_side(self.__play_side_idx, Color.off)
        self.pad:set_side(self.__play_side_idx, self.color.playing)
    else
        self.pad:set_side(self.__play_side_idx, self.color.not_playing)
    end
end

function RecordButton:__clear_button()
    self.pad:set_side(self.__record_side_idx, Color.off)
    self.pad:set_side(self.__play_side_idx, Color.off)
end
