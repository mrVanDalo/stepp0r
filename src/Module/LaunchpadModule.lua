-- --
-- mode super class
class "LaunchpadModule"


function LaunchpadModule:__init()
    self.is_active = false
end

function LaunchpadModule:activate()
    self.is_active = true
    self:_activate()
end

function LaunchpadModule:deactivate()
    self.is_active = false
    self:_deactivate()
end

function LaunchpadModule:__tostring()
  return ("LaunchpadModule : %s"):format(self.is_active)
end
