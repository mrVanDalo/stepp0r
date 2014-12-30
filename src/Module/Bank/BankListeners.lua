
--- ======================================================================================================
---
---                                                 [ Bank update Listeners ]
--
-- The update will give you a reference to the actual bank.
-- so you your callbanks have to write stuff to the bank itself.

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]

function Bank:__init_listeners()
    self.bank_update_listeners = {}
end
function Bank:__activate_listeners()
    self:_update_bank_listeners()
end
function Bank:__deactivate_listeners()
end


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Bank:register_bank_update(handler)
    self.bank_update_listeners[handler] = handler
end

function Bank:unregister_bank_updater(handler)
    self.bank_update_listeners[handler] = nil
end

function Bank:_update_bank_listeners()
    -- assure bank at index exists
    local new_bank = self.banks[self.bank_idx]
    -- loop over all listeners
    for _, handler in pairs(self.bank_update_listeners) do
        handler(new_bank, self.mode)
    end
end


