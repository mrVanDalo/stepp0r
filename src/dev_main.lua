require 'Launchpad'
require 'Module/LaunchpadModule'
require 'Module/KeyboardModule'
require 'Module/Chooser'
require 'Module/Stepper'

print('load dev main')

pad = Launchpad()

key = KeyboardModule()
key:wire_launchpad(pad)

chooser = Chooser()
chooser:wire_launchpad(pad)
chooser:register_select_instrument(key:callback_set_instrument())

stepper = Stepper()
stepper.wire_launchpad(pad)



key:activate()
chooser:activate()
stepper:activate()

function off()
    key:deactivate()
end
