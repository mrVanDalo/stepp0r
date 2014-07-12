-- --
-- mode super class
--
-- this class should some-how define how every module should behave
-- which should make creating modes easier
--
-- A mode is a mix of modules
--

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
