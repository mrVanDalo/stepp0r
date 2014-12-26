--- ======================================================================================================
---
---                                                 [ Bank Module ]
-- to store Copy paste Pattern

class "Bank" (Module)

require 'Module/Bank/BankBoot'
require 'Module/Bank/BankCallbacks'
require 'Module/Bank/BankLibrary'
require 'Module/Bank/BankRender'

BankData = {
    mode = {
        copy  = 1,
        paste = 2,
    },
}


function Bank:__init()
    Module:__init(self)

    self.offset = 6

    self.color = {
        toggle = {
            selected = {
                copy =  Color.flash.green,
                paste = Color.flash.red,
            },
            unselected = Color.orange,
        },
        clear = Color.red,
    }

    self.banks    = {}
    self.bank_idx = 1 -- active bank right now
    self.mode     = BankData.mode.copy

    self.pad = nil
    self.bank_update_listeners = {}
    self:_create_boot_callbacks()
end


function Bank:wire_launchpad(pad)
    self.pad = pad
end

