--- ======================================================================================================
---
---                                                 [ Bank Module ]
-- to store Copy paste Pattern

class "Bank" (Module)

require 'Module/Bank/BankCallbacks'
require 'Module/Bank/BankLibrary'
require 'Module/Bank/BankLaunchpadMatrix'

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


    self:__init_matrix()
    self:__init_listeners()

end

function Bank:_activate()
    self:__activate_matrix()
    self:__activate_listeners()
    self:_render_matrix()
end

function Bank:_deactivate()
    self:__deactivate_matrix()
    self:__deactivate_listeners()
    self:_clear_matrix()
end

function Bank:wire_launchpad(pad)
    self.pad = pad
end
