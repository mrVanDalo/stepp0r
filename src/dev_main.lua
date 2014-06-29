require 'Launchpad'
require 'Module/LaunchpadModule'
require 'Module/KeyboardModule'

print('load dev main')


pad         = Launchpad()

instruments = Instruments()
instruments:create_instrument()
instruments:set_active_instrument(1)

key         = KeyboardModule(pad,instruments)
key:activate()

function off()
    key:deactivate()
end
