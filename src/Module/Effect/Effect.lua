--- ======================================================================================================
---
---                                                 [ Effect Module ]

--- updaten an manage Effect information


class "Effect" (Module)

require "Module/Effect/EffectDelay"
require "Module/Effect/EffectVolume"
require "Module/Effect/EffectPanning"
require "Module/Effect/EffectMode"


EffectData = {
    mode = {
        DELAY  = {1, Color.yellow},
        PAN    = {2, Color.green },
        VOLUME = {3, Color.orange},
    },
    access = {
        color = 2,
    }
}

--- ======================================================================================================
---
---                                                 [ INIT ]

function Effect:__init()
    Module:__init(self)
    self.mode   = EffectData.mode.DELAY
    self.delay  = 1 -- init values
    self.pan    = 0 -- init values
    self.volume = 1 -- init values
    -- configuration
    self.row           = 5
    self.mode_knob_idx = self.row
    self.color = {
        on  = Color.orange,
        off = Color.off,
    }
    self.callbacks_set_delay  = {}
    self.callbacks_set_pan    = {}
    self.callbacks_set_volume = {}

    self:__create_callbacks()
end

function Effect:wire_launchpad(pad)
    self.pad = pad
end

--- register a listener on the set delay
-- callbacks will receive a number 0-255
-- 0 is empty
function Effect:register_set_delay(callback)
    table.insert(self.callbacks_set_delay,callback)
end
--- register a listener on the set pan
-- callbacks will receive a number 0-127
-- 255 is empty
-- 64 is the center
function Effect:register_set_pan(callback)
    table.insert(self.callbacks_set_pan,callback)
end
--- register a listener on the set volume
-- callbacks will receive a number 0-127
-- 255 is empty
function Effect:register_set_volume(callback)
    table.insert(self.callbacks_set_volume,callback)
end

function Effect:__create_callbacks()
    self:__create_callback_set_instrument()
    self:__create_matrix_listener()
    self:__create_mode_listener()
end


--- ======================================================================================================
---
---                                                 [ boot ]

function Effect:_activate()
    -- todo send default value to all registered listeners
    self:refresh()
    self.pad:register_matrix_listener(self.matrix_listener)
    self.pad:register_right_listener(self.mode_listener)
end

function Effect:_deactivate()
    self:matrix_clear()
    self.pad:set_side(self.mode_knob_idx,Color.off)
    self.pad:unregister_matrix_listener(self.matrix_listener)
    self.pad:unregister_right_listener(self.mode_listener)
end

function Effect:__create_mode_listener()
    self.mode_listener = function (_,msg)
        if self.is_not_active          then return end
        if msg.vel == Velocity.release then return end
        if msg.x ~= self.mode_knob_idx then return end
        self:next_mode()
    end
end

function Effect:__create_matrix_listener()
    self.matrix_listener = function (_,msg)
        if self.is_not_active          then return end
        if msg.vel == Velocity.release then return end
        if msg.y ~= self.row           then return end
        if     self.mode == EffectData.mode.DELAY  then self:set_delay(msg.x)
        elseif self.mode == EffectData.mode.VOLUME then self:set_volume(msg.x)
        else                                            self:set_pan(msg.x)
        end
    end
end

function Effect:__create_callback_set_instrument()
    self.callback_set_instrument = function (_,_,_)
        if self.is_not_active then return end
        self:set_delay(1)
        self:set_volume(1)
        self:set_pan(0)
    end
end




--- ======================================================================================================
---
---                                                 [ Rendering ]

function Effect:matrix_clear()
    for i = 1, 8 do
        self.pad:set_matrix(i, self.row,self.color.off)
    end
end

function Effect:matrix_refresh()
    self:matrix_clear()
    if self.mode == EffectData.mode.DELAY then
        self:matrix_update_delay()
    elseif self.mode == EffectData.mode.PAN then
        self:matrix_update_pan()
    else
        self:matrix_update_volume()
    end
end

function Effect:refresh()
    self:matrix_refresh()
    self:right_refresh()
end

