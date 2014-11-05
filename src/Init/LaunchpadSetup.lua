
require 'Data/Color'
require 'Data/Note'
require 'Data/Velocity'

require 'Layer/Launchpad'
require 'Layer/PlaybackPositionObserver'
require 'Layer/OscClient'
require 'Layer/Util'
require 'Layer/IT_Selection'

require 'Module/Module'
require 'Module/Keyboard'
require 'Module/Chooser'
require 'Module/Stepper'
require 'Module/Stepper_render'
require 'Module/Effect'

require 'Module/Adjuster'
require 'Module/Adjuster/AdjusterBank'
require 'Module/Adjuster/AdjusterBoot'
require 'Module/Adjuster/AdjusterCallbacks'
require 'Module/Adjuster/AdjusterLibrary'
require 'Module/Adjuster/AdjusterPagination'
require 'Module/Adjuster/AdjusterPattern'
require 'Module/Adjuster/AdjusterZoom'

require 'Module/Bank'

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
    self.it_selection      = nil
    -- modules
    self.stepper           = nil
    self.effect            = nil
    self.key               = nil
    self.bank              = nil
    self.chooser           = nil
end

function LaunchpadSetup:deactivate()
    -- modules
--    self.key:deactivate()
    self.bank:deactivate()
    self.stepper:deactivate()
    self.chooser:deactivate()
    self.effect:deactivate()
    -- layers
    self.osc_client:disconnect()
    self.pad:disconnect()
end

function LaunchpadSetup:activate()
    -- modules
--    self.key:activate()
    self.bank:activate()
    self.stepper:activate()
    self.chooser:activate()
    self.effect:activate()
    -- boot
    self.it_selection:boot()
end

function LaunchpadSetup:connect_launchpad(pad_name)
    self.pad:disconnect()
    self.pad:connect(pad_name)
end

function LaunchpadSetup:connect_it_selection()
    self.it_selection:disconnect()
    self.it_selection:connect()
end

function LaunchpadSetup:connect_osc_client(host, port)
    self.osc_client:disconnect()
    self.osc_client:set_host(host)
    self.osc_client:set_port(port)
    self.osc_client:start()
end


function LaunchpadSetup:wire()
    --- layers are the basic connection
    -- they are used to change while the system is inactive
    -- layers should not be changed after the system is active
    -- If you want to do that you have to deactivate the system first.
    self.pad = Launchpad()
    self.playback_position_observer = PlaybackPositionObserver()
    self.osc_client = OscClient()
    self.it_selection = IT_Selection()

--    self.stepper = Stepper()
    self.stepper = Adjuster()
    self.stepper:wire_launchpad(self.pad)
    self.stepper:wire_playback_position_observer(self.playback_position_observer)

    self.effect = Effect()
    self.effect:wire_launchpad(self.pad)
    self.effect:register_set_delay (self.stepper:callback_set_delay())
    self.effect:register_set_volume(self.stepper:callback_set_volume())
    self.effect:register_set_pan   (self.stepper:callback_set_pan())

--    self.key = Keyboard()
--    self.key:wire_launchpad(self.pad)
--    self.key:wire_osc_client(self.osc_client)
--    self.key:register_set_note(self.stepper:callback_set_note())

    self.bank = Bank()
    self.bank:wire_launchpad(self.pad)
    self.bank:register_bank_update(self.stepper.bank_update_handler)

    self.chooser = Chooser()
    self.chooser:wire_launchpad(self.pad)
    self.chooser:wire_it_selection(self.it_selection)

    --- Layer callback registration
--    self.it_selection:register_select_instrument(self.key:callback_set_instrument())
    self.it_selection:register_select_instrument(self.stepper:callback_set_instrument())
    self.it_selection:register_select_instrument(self.effect:callback_set_instrument())
    self.it_selection:register_select_instrument(self.chooser:callback_set_instrument())

end

