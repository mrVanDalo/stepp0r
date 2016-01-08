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
    },
}

function StepperMode:__init()
    Module:__init(self)
    self.color = {
        mode = {},
        off = Color.off
    }
    self.knob_idx = 8
    self.color.mode[StepperModeData.mode.copy_paste] = NewColor[3][0]
    self.color.mode[StepperModeData.mode.edit]       = NewColor[3][3]

    self.mode = StepperModeData.mode.edit
    self.callbacks = {}
    self:__create_side_listener()
end

function StepperMode:wire_launchpad(pad)
    self.pad = pad
end

function StepperMode:register_mode_update_callback(callback)
    table.insert(self.callbacks, callback)
end

function StepperMode:__create_side_listener()
    self.side_listener = function (_,msg)
        if (msg.vel == Velocity.press) then return end
        if (msg.x ~= self.knob_idx) then return end
        self:__toggle_mode()
        self:__update_mode()
        self:__render_knob()
    end
end

function StepperMode:__render_knob()
    self.pad:set_side(self.knob_idx, self.color.mode[self.mode])
end

function StepperMode:__clear_knob()
    self.pad:set_side(self.knob_idx, self.color.off)
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
    self.pad:register_side_listener(self.side_listener)
    self:__update_mode()
    self:__render_knob()
end

function StepperMode:_deactivate()
    self.pad:unregister_side_listener(self.side_listener)
    self:__clear_knob()
end
