require 'Launchpad'
require 'Module/LaunchpadModule'
require 'Module/KeyboardModule'
require 'Module/Chooser'

print('load dev main')

pad         = Launchpad()

key         = KeyboardModule()
key:wire_launchpad(pad)

chooser     = Chooser()
chooser:wire_launchpad(pad)


key:activate()
chooser:activate()

function off()
    key:deactivate()
end
