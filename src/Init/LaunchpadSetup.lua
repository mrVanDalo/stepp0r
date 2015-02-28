
require 'Data/Color'
require 'Data/Note'
require 'Data/Velocity'

require 'Layer/Launchpad/Launchpad'
require 'Layer/PlaybackPositionObserver'
require 'Layer/OscClient'
require 'Layer/Util'
require 'Layer/IT_Selection/IT_Selection'

require 'Module/Module'
require 'Module/PatternEditorModule/PatternEditorModule'

require 'Mode/Mode'
require 'Mode/StepperMode'

require 'Module/Adjuster/Adjuster'
require 'Module/Bank/Bank'
require 'Module/Paginator/Paginator'
require 'Module/Editor/Editor'
require 'Module/Chooser/Chooser'
require 'Module/Effect/Effect'
require 'Module/Keyboard/Keyboard'

require 'Module/PatternMatrix/PatternMatrix'


--- ======================================================================================================
---
---                                                 [ Launchpad Setup ]
--- To Setup for the main


class "LaunchpadSetup"

LaunchpadSetupData = {
    rotation = {
        left  = 1,
        right = 2,
    }
}



function LaunchpadSetup:__init()
    -- layer
    self.pad                 = nil
    self.playback_position_observer = nil
    self.osc_client          = nil
    self.it_selection        = nil
    -- modules
    self.editor              = nil
    self.adjuster            = nil
    self.effect              = nil
    self.key                 = nil
    self.bank                = nil
    self.chooser             = nil
    self.paginator           = nil
    self.pattern_matrix      = nil
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
    self.it_selection:disconnect()
end

function LaunchpadSetup:activate()
    -- boot
    self.it_selection:boot()
    -- modules
    self.stepper_mode_module:activate()
    self.stepper_mode:activate()
    self.chooser:activate()
    self.paginator:activate()
    self.effect:activate()
end

function LaunchpadSetup:connect_launchpad(pad_name,rotation)
    self.pad:disconnect()
    if (rotation == LaunchpadSetupData.rotation.right) then
        self.pad:rotate_right()
    else
        self.pad:rotate_left()
    end
    self.pad:connect(pad_name)
end

function LaunchpadSetup:connect_osc_client(host, port)
    self.osc_client:disconnect()
    self.osc_client:connect(host, port)
end

function LaunchpadSetup:connect_it_selection()
    self.it_selection:disconnect()
    self.it_selection:connect()
end

function LaunchpadSetup:set_follow_mute()
    self.chooser:set_follow_mute()
end

function LaunchpadSetup:unset_follow_mute()
    self.chooser:unset_follow_mute()
end

function LaunchpadSetup:set_follow_track_instrument()
    self.it_selection:set_follow_track_instrument()
end

function LaunchpadSetup:unset_follow_track_instrument()
    self.it_selection:unset_follow_track_instrument()
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
    --- Modules are the things you can see on the launchpad
    -- or route informations between modules
    -- or toggle modules on and off
    --
    self.editor = Editor()
    self.editor:wire_launchpad(self.pad)
    self.editor:wire_playback_position_observer(self.playback_position_observer)
    --
    self.adjuster = Adjuster()
    self.adjuster:wire_launchpad(self.pad)
    self.adjuster:wire_playback_position_observer(self.playback_position_observer)
    --
    self.effect = Effect()
    self.effect:wire_launchpad(self.pad)
    self.effect:register_set_delay (self.editor.callback_set_delay)
    self.effect:register_set_volume(self.editor.callback_set_volume)
    self.effect:register_set_pan   (self.editor.callback_set_pan)
    self.effect:register_set_delay (self.adjuster.callback_set_delay)
    self.effect:register_set_volume(self.adjuster.callback_set_volume)
    self.effect:register_set_pan   (self.adjuster.callback_set_pan)
    --
    self.key = Keyboard()
    self.key:wire_launchpad(self.pad)
    self.key:wire_osc_client(self.osc_client)
    self.key:register_set_note(self.editor.callback_set_note)
    --
    self.bank = Bank()
    self.bank:wire_launchpad(self.pad)
    self.bank:register_bank_update(self.adjuster.bank_update_handler)
    --
    self.chooser = Chooser()
    self.chooser:wire_launchpad(self.pad)
    self.chooser:wire_it_selection(self.it_selection)
    --
    self.paginator = Paginator()
    self.paginator:wire_launchpad(self.pad)
    self.paginator:register_update_callback(self.adjuster.pageinator_update_callback)
    self.paginator:register_update_callback(self.editor.pageinator_update_callback)
    --
    self.pattern_matrix = PatternMatrix()
    self.pattern_matrix:wire_launchpad(self.pad)
    --- Stepper Mode
    -- is the mode that toggels the Editor and Keyboard Kombo with the Adjuster and Bank Kombo
    self.stepper_mode = Mode()
    self.stepper_mode:add_module_to_mode(StepperModeData.mode.edit, self.key)
    self.stepper_mode:add_module_to_mode(StepperModeData.mode.edit, self.editor)
    self.stepper_mode:add_module_to_mode(StepperModeData.mode.edit, self.chooser)
    self.stepper_mode:add_module_to_mode(StepperModeData.mode.edit, self.effect)
    self.stepper_mode:add_module_to_mode(StepperModeData.mode.edit, self.paginator)
--    self.stepper_mode:add_module_to_mode(StepperModeData.mode.copy_paste, self.bank)
--    self.stepper_mode:add_module_to_mode(StepperModeData.mode.copy_paste, self.adjuster)
    self.stepper_mode:add_module_to_mode(StepperModeData.mode.copy_paste, self.pattern_matrix)
    --
    self.stepper_mode_module = StepperMode()
    self.stepper_mode_module:wire_launchpad(self.pad)
    self.stepper_mode_module:register_mode_update_callback(self.stepper_mode.mode_update_callback)
    --- Layer callback registration
    self.it_selection:register_select_instrument(self.key.callback_set_instrument)
    self.it_selection:register_select_instrument(self.editor.callback_set_instrument)
    self.it_selection:register_select_instrument(self.adjuster.callback_set_instrument)
    self.it_selection:register_select_instrument(self.effect.callback_set_instrument)
    self.it_selection:register_select_instrument(self.chooser.callback_set_instrument)
    self.it_selection:register_select_instrument(self.pattern_matrix.callback_set_instrument)
    --
    self.it_selection:register_select_pattern(self.editor.callback_set_pattern)
    self.it_selection:register_select_pattern(self.adjuster.callback_set_pattern)
    self.it_selection:register_select_pattern(self.paginator.callback_set_pattern)
    --
    self.it_selection:register_idle(self.editor.idle_callback)
    self.it_selection:register_idle(self.adjuster.idle_callback)

end

