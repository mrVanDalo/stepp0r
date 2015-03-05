--- ======================================================================================================
---
---                                                 [ Pattern Mode ]
---
--- to toggle between Pattern Edit and Pattern Matrix mode
--- must be connected by a Mode.

class "PatternMode" (Module)

PatternModeData = {
    mode = {
        edit_mode   = 1,
        matrix_mode = 2
    },
}

function PatternMode:__init()
    Module:__init(self)
    self.color = {
        mode = {},
        off = Color.off
    }
    self.knob_idx = 8
    self.color.mode[PatternModeData.mode.matrix_mode] = NewColor[1][3]
    self.color.mode[PatternModeData.mode.edit_mode]   = NewColor[3][1]

    self.mode = PatternModeData.mode.edit_mode
    self.callbacks = {}
    self:__create_top_listener()
end

function PatternMode:wire_launchpad(pad)
    self.pad = pad
end

function PatternMode:register_mode_update_callback(callback)
    table.insert(self.callbacks, callback)
end

function PatternMode:__create_top_listener()
    self.top_listener = function (_,msg)
        if (msg.vel == Velocity.press) then return end
        if (msg.x ~= self.knob_idx) then return end
        self:__toggle_mode()
        self:__update_mode()
        self:__render_knob()
    end
end

function PatternMode:__render_knob()
    self.pad:set_top(self.knob_idx, self.color.mode[self.mode])
end

function PatternMode:__clear_knob()
    self.pad:set_top(self.knob_idx, Color.off)
end

function PatternMode:__toggle_mode()
    if (self.mode == PatternModeData.mode.edit_mode ) then
        self.mode = PatternModeData.mode.matrix_mode
    else
        self.mode = PatternModeData.mode.edit_mode
    end
end

function PatternMode:__update_mode()
    for _, callback in ipairs(self.callbacks) do
        callback(self.mode)
    end
end

function PatternMode:_activate()
    self.pad:register_top_listener(self.top_listener)
    self:__update_mode()
    self:__render_knob()
end

function PatternMode:_deactivate()
    self:__clear_knob()
    self.pad:unregister_top_listener(self.top_listener)
end
