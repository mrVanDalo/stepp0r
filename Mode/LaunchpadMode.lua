-- --
-- mode super class
class "LaunchpadMode"


function LaunchpadMode:__init(pad)
    self.pad       = pad
    self.is_active = false
end

function LaunchpadMode:activate()
    self.is_active = true
    self:_activate()
end

function LaunchpadMode:deactivate()
    self.is_active = false
    self:_deactivate()
end
