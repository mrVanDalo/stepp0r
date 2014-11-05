

--- ======================================================================================================
---
---                                                 [ Bank update Listeners ]

function Bank:register_bank_update(handler)
    self.bank_update_listeners[handler] = handler
end

function Bank:unregister_bank_updater(handler)
    self.bank_update_listeners[handler] = nil
end

function Bank:_update_bank_listeners()
    -- assure bank at index exists
    local new_bank = self.banks[self.bank_idx]
    if not new_bank then
        self.banks[self.bank_idx] = {}
        new_bank = self.banks[self.bank_idx]
    end
    -- loop over all listeners
    for _, handler in pairs(self.bank_update_listeners) do
        handler(new_bank)
    end
end


--- ======================================================================================================
---
---                                                 [ Bank set listeners ]


