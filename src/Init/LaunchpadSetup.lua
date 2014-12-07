
require 'Data/Color'
require 'Data/Note'
require 'Data/Velocity'

require 'Layer/Launchpad/Lanchpad'
require 'Layer/PlaybackPositionObserver'
require 'Layer/OscClient'
require 'Layer/Util'
require 'Layer/IT_Selection'

require 'Module/Module'

require 'Mode/Mode'
require 'Mode/StepperMode'

require 'Module/Adjuster/Adjuster'
require 'Module/Bank/Bank'
require 'Module/Paginator/Paginator'
require 'Module/Stepper/Stepper'
require 'Module/Chooser/Chooser'
require 'Module/Effect/Effect'
require 'Module/Keyboard/Keyboard'

--- ======================================================================================================
---
---                                                 [ Launchpad Setup ]
--- To Setup for the main


class "LaunchpadSetup"



function LaunchpadSetup:__init()
    -- layer
    self.pad                 = nil
    self.playback_position_observer = nil
    self.osc_client          = nil
    self.it_selection        = nil
    -- modules
    self.stepper             = nil
    self.adjuster            = nil
    self.effect              = nil
    self.key                 = nil
    self.bank                = nil
    self.chooser             = nil
    self.paginator           = nil
    -- modes
    self.stepper_mode_module = nil
    self.stepper_mode        = nil
end

function LaunchpadSetup:deactivate()
    -- modules
    self.stepper_mode_module:deactivate()
    self.stepper_mode:deactivate()
    self.chooser:deactivate()
    self.paginator:deactivate()
    self.effect:deactivate()
    -- layers
    self.osc_client:disconnect()
    self.pad:disconnect()
end

function LaunchpadSetup:activate()
    -- modules
    self.stepper_mode_module:activate()
    self.stepper_mode:activate()
    self.chooser:activate()
    self.paginator:activate()
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

    self.stepper = Stepper()
    self.stepper:wire_launchpad(self.pad)
    self.stepper:wire_playback_position_observer(self.playback_position_observer)

    self.adjuster = Adjuster()
    self.adjuster:wire_launchpad(self.pad)
    self.adjuster:wire_playback_position_observer(self.playback_position_observer)

    self.effect = Effect()
    self.effect:wire_launchpad(self.pad)
    self.effect:register_set_delay (self.stepper.callback_set_delay)
    self.effect:register_set_volume(self.stepper.callback_set_volume)
    self.effect:register_set_pan   (self.stepper.callback_set_pan)
    self.effect:register_set_delay (self.adjuster.callback_set_delay)
    self.effect:register_set_volume(self.adjuster.callback_set_volume)
    self.effect:register_set_pan   (self.adjuster.callback_set_pan)

    self.key = Keyboard()
    self.key:wire_launchpad(self.pad)
    self.key:wire_osc_client(self.osc_client)
    self.key:register_set_note(self.stepper.callback_set_note)

    self.bank = Bank()
    self.bank:wire_launchpad(self.pad)
    self.bank:register_bank_update(self.adjuster.bank_update_handler)

    self.chooser = Chooser()
    self.chooser:wire_launchpad(self.pad)
    self.chooser:wire_it_selection(self.it_selection)

    self.paginator = Paginator()
    self.paginator:wire_launchpad(self.pad)
    self.paginator:register_update_callback(self.adjuster.pageinator_update_callback)
    self.paginator:register_update_callback(self.stepper.pageinator_update_callback)

    --- Stepper Mode
    self.stepper_mode = Mode()
    self.stepper_mode:add_module_to_mode(StepperModeData.mode.edit, self.key)
    self.stepper_mode:add_module_to_mode(StepperModeData.mode.edit, self.stepper)
    self.stepper_mode:add_module_to_mode(StepperModeData.mode.copy_paste, self.bank)
    self.stepper_mode:add_module_to_mode(StepperModeData.mode.copy_paste, self.adjuster)
    self.stepper_mode_module = StepperMode()
    self.stepper_mode_module:wire_launchpad(self.pad)
    self.stepper_mode_module:register_mode_update_callback(self.stepper_mode.mode_update_callback)

    --- Layer callback registration
    self.it_selection:register_select_instrument(self.key.callback_set_instrument)
    self.it_selection:register_select_instrument(self.stepper.callback_set_instrument)
    self.it_selection:register_select_instrument(self.adjuster.callback_set_instrument)
    self.it_selection:register_select_instrument(self.effect.callback_set_instrument)
    self.it_selection:register_select_instrument(self.chooser.callback_set_instrument)

end

