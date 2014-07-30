

require 'Layer/Launchpad'
require 'Module/Module'
require 'Module/Keyboard'
require 'Module/Chooser'
require 'Module/Stepper'
require 'Module/Effect'


--- ======================================================================================================
---
---                                                 [ Launchpad Setup ]
--- To Setup for the main


class "LaunchpadSetup"



function LaunchpadSetup:__init()
    self.pad               = nil
    self.stepper           = nil
    self.effect            = nil
    self.key               = nil
    self.chooser           = nil
end

function LaunchpadSetup:deactivate()
    self.key:deactivate()
    self.stepper:deactivate()
    self.chooser:deactivate()
    self.effect:deactivate()
end

function LaunchpadSetup:activate()
    self.key:activate()
    self.stepper:activate()
    self.chooser:activate()
    self.effect:activate()
end

function LaunchpadSetup:connect(pad_name)
    self.pad:connect(pad_name)
end

function LaunchpadSetup:wire()
    self.pad = Launchpad()

    self.stepper = Stepper()
    self.stepper:wire_launchpad(self.pad)

    self.effect = Effect()
    self.effect:wire_launchpad(self.pad)
    self.effect:register_set_delay (self.stepper:callback_set_delay())
    self.effect:register_set_volume(self.stepper:callback_set_volume())
    self.effect:register_set_pan   (self.stepper:callback_set_pan())

    self.key = Keyboard()
    self.key:wire_launchpad(self.pad)
    self.key:register_set_note(self.stepper:callback_set_note())

    self.chooser = Chooser()
    self.chooser:wire_launchpad(self.pad)
    self.chooser:register_select_instrument(self.key:callback_set_instrument())
    self.chooser:register_select_instrument(self.stepper:callback_set_instrument())
    self.chooser:register_select_instrument(self.effect:callback_set_instrument())
end

