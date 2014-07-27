--- ======================================================================================================
---
---                                                 [ Module ]
--- mode super class
---
--- this class should some-how define how every module should behave
--- which should make creating modes easier
---
--- A mode is a mix of modules

class "Module"

function Module:__init(self)
    self.is_active     = false
    self.is_not_active = true
    self.first_run     = true   -- is this the first run
    self.is_first_run  = true   -- is this the first run
end

function Module:activate()
    self.is_active     = true
    self.is_not_active = false
    self:_activate()
    self.first_run     = false
    self.is_first_run  = false
end

--- to deactivate this Module
-- everything that is active now should be roled back
-- clear matrix etc. But don't unregsiter yourself or something.
--
-- The Module should be able to activate afterwards
function Module:deactivate()
    self.is_active     = false
    self.is_not_active = true
    self:_deactivate()
end

function Module:__tostring()
  return ("Module : %s"):format(self.is_active)
end
