
--- ======================================================================================================
---
---                                                 [ Idel App ]

--- to let apps refresh them self. In a proper way, so you can handle a bit heavier calculations in the idle time.


function IT_Selection:_init_idle()
    self.callback_idle = {}
    self.callback_idle_idx = 1  -- the next callback that will be called
    self.skip_size = 10         -- how many times idle should be skipped
    self.skip_counter = 1
    self:__create_idle_listener()
end

function IT_Selection:_boot_idle()
end


function IT_Selection:_connect_idle()
    add_notifier(renoise.tool().app_idle_observable, self.__idle_listener)
end

function IT_Selection:_disconnect_idle()
    remove_notifier(renoise.tool().app_idle_observable, self.__idle_listener)
end

function IT_Selection:register_idle(callback)
    table.insert(self.callback_idle, callback)
end

function IT_Selection:__create_idle_listener()
    self.__idle_listener = function ()
        self.skip_counter = (self.skip_counter + 1) % self.skip_size
        if (self.skip_counter ~=  0 ) then return end

        local number_of_callbacks = table.getn(self.callback_idle)
        if number_of_callbacks == 0 then return end
        if self.callback_idle_idx > number_of_callbacks then
            self.callback_idle_idx = 1
        end

        local next_callback = self.callback_idle[self.callback_idle_idx]
        self.callback_idle_idx = self.callback_idle_idx + 1
        if next_callback then
            next_callback()
        end
    end
end
