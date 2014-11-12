--- ======================================================================================================
---
---                                                 [ Stepper Mode ]
---
--- to toggle between Adjuster and Stepper
--- must be connected by a Mode.

class "StepperMode" (Module)

StepperModeData = {
    mode = {
        edit       = 1,
        copy_paste = 2
    }
}

function StepperMode:__init()
    Module:__init(self)
    self.mode = StepperModeData.mode.edit
    self.callbacks = {}
    self:__create_top_listener()
end

function StepperMode:wire_launchpad(pad)
    self.pad = pad
end

function StepperMode:register_mode_update_callback(callback)
    table.insert(self.callbacks, callback)
end

function StepperMode:__create_top_listener()
    self.top_listener = function (_,msg)
        if (msg.vel == Velocity.press) then return end
        if (msg.x ~= 8) then return end
        self:__toggle_mode()
        self:__update_mode()
    end
end

function StepperMode:__toggle_mode()
    if (self.mode == StepperModeData.mode.edit ) then
        self.mode = StepperModeData.mode.copy_paste
    else
        self.mode = StepperModeData.mode.edit
    end
end

function StepperMode:__update_mode()
    for _, callback in ipairs(self.callbacks) do
        callback(self.mode)
    end
end

function StepperMode:_activate()
    self.pad:register_top_listener(self.top_listener)
    self:__update_mode()
end

function StepperMode:_deactivate()
    self.pad:unregister_top_listener(self.top_listener)
end
