--- ======================================================================================================
---
---                                                 [ Bank Module ]
-- to store Copy paste Pattern


BankData = {
    mode = {
        copy  = 1,
        paste = 2,
    }
}

class "Bank" (Module)

function Bank:__init(self)
    Module:__init(self)
    self.offset = 6
    -- default
    self.color = {

    }
    self.banks    = {}
    self.bank_idx = 1 -- active bank right now

    self.pad = nil
    self.bank_update_listeners = {}
    self:_first_run() -- todo move me to Module class
end


function Bank:wire_launchpad(pad)
    self.pad = pad
end

