

require 'Layer/Launchpad'
require 'Layer/PlaybackPositionObserver'
require 'Layer/OscClient'
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
    -- layer
    self.pad               = nil
    self.playback_position_observer = nil
    self.osc_client        = nil
    -- modules
    self.stepper           = nil
    self.effect            = nil
    self.key               = nil
    self.chooser           = nil
end

function LaunchpadSetup:deactivate()
    -- modules
    self.key:deactivate()
    self.stepper:deactivate()
    self.chooser:deactivate()
    self.effect:deactivate()
    -- layers
    self.osc_client:tear_down()
end

function LaunchpadSetup:activate()
    -- layers
    self.osc_client:start()
    -- modules
    self.key:activate()
    self.stepper:activate()
    self.chooser:activate()
    self.effect:activate()
end

function LaunchpadSetup:connect(pad_name)
    self.pad:disconnect()
    self.pad:connect(pad_name)
end

function LaunchpadSetup:wire()
    --- layers are the basic connection
    -- they are used to change while the system is inactive
    -- layers should not be changed after the system is active
    -- If you want to do that you have to deactivate the system first.
    self.pad = Launchpad()
    self.playback_position_observer = PlaybackPositionObserver()
    self.osc_client = OscClient()

    self.stepper = Stepper()
    self.stepper:wire_launchpad(self.pad)
    self.stepper:wire_playback_position_observer(self.playback_position_observer)

    self.effect = Effect()
    self.effect:wire_launchpad(self.pad)
    self.effect:register_set_delay (self.stepper:callback_set_delay())
    self.effect:register_set_volume(self.stepper:callback_set_volume())
    self.effect:register_set_pan   (self.stepper:callback_set_pan())

    self.key = Keyboard()
    self.key:wire_launchpad(self.pad)
    self.key:wire_osc_client(self.osc_client)
    self.key:register_set_note(self.stepper:callback_set_note())

    self.chooser = Chooser()
    self.chooser:wire_launchpad(self.pad)
    self.chooser:register_select_instrument(self.key:callback_set_instrument())
    self.chooser:register_select_instrument(self.stepper:callback_set_instrument())
    self.chooser:register_select_instrument(self.effect:callback_set_instrument())
end

