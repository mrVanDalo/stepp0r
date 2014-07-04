require 'Launchpad'
require 'Module/LaunchpadModule'
require 'Module/KeyboardModule'

print('load dev main')


pad         = Launchpad()

key         = KeyboardModule(pad,1)
key:activate()

function off()
    key:deactivate()
end
