

function PlayRecordButton:__init_launchpad()
    self.__top_idx = 7
    self:__create_button_listener()
    self:__create_observer()
    self:__create_idle_callback()
    self.__waiting = false
    self.__waiting_counter_max = 1
end
function PlayRecordButton:__activate_launchpad()
    --print("activate play record button")
    self.pad:register_top_listener(self.__button_listener)
    self:_refresh_buttons()
    -- is triggerd when the play status changes
    add_notifier(renoise.song().transport.playing_observable, self.__observer)
    add_notifier(renoise.song().transport.edit_mode_observable, self.__observer)
end
function PlayRecordButton:__deactivate_launchpad()
    remove_notifier(renoise.song().transport.playing_observable, self.__observer)
    remove_notifier(renoise.song().transport.edit_mode_observable, self.__observer)
    self:__clear_button()
    self.pad:unregister_top_listener(self.__button_listener)
end

function PlayRecordButton:__create_observer()
    self.__observer = function (_)
        if self.is_not_active then return end
        self:_refresh_buttons()
    end
end

function PlayRecordButton:__create_button_listener()
    self.__button_listener = function (_,msg)
        if self.is_not_active then return end
        if msg.x ~= self.__top_idx then return end
        if msg.vel ~= Velocity.release then
            -- long click ?
            self:start_waiting_to_stop()
        else
            -- short click ?
            self.__waiting = false
            if self.__has_stopped then return end
            self:_toggle_mode()
            self:_refresh_buttons()
        end
    end
end
function PlayRecordButton:start_waiting_to_stop()
    -- todo: start the waiting interval
    self.__has_stopped = false
    self.__waiting = true
    self.__waiting_counter = 0
end

function PlayRecordButton:__create_idle_callback()
    self.idle_callback = function()
        if self.__waiting then
            print("incriment counter " .. self.__waiting_counter)
            if self.__waiting_counter < self.__waiting_counter_max then
                self.__waiting_counter = self.__waiting_counter + 1
            else
                self.__waiting = false
                self.__has_stopped = true
                Renoise.transport:stop_recording()
                Renoise.transport:stop_playing()
            end
        end
    end
end

function PlayRecordButton:_toggle_mode()
    if Renoise.transport:is_playing() and Renoise.transport:is_recording() then
        Renoise.transport:stop_recording()
    elseif Renoise.transport:is_playing() then
        Renoise.transport:start_recording()
    else
        Renoise.transport:start_playing()
        Renoise.transport:stop_recording()
    end
end

function PlayRecordButton:_refresh_buttons()
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

function PlayRecordButton:__clear_button()
    self.pad:set_top(self.__top_idx, Color.off)
end
