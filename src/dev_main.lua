require 'Launchpad'
require 'Module/LaunchpadModule'
require 'Module/KeyboardModule'
require 'Module/Chooser'

print('load dev main')

pad         = Launchpad()
key         = KeyboardModule(pad,1)
chooser     = Chooser(pad)

key:activate()
chooser:activate()

function off()
    key:deactivate()
end
