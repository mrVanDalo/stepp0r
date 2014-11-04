

--- ======================================================================================================
---
---                                                 [ Bank update Listeners ]

function Bank:_update_bank_listeners()
    for _, handler in pairs(self.bank_update_listeners) do
        handler(self.bank[self.bank_idx])
    end
end

function Bank:register_bank_update(handler)
    self.bank_update_listeners[handler] = handler
end

function Bank:unregister_bank_updater(handler)
    self.bank_update_listeners[handler] = nil
end


--- ======================================================================================================
---
---                                                 [ Bank set listeners ]


