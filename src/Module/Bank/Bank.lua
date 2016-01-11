--- ======================================================================================================
---
---                                                 [ Bank Module ]
-- to store Copy paste Pattern

class "Bank" (Module)

require 'Module/Bank/BankListeners'
require 'Module/Bank/BankLaunchpadMatrix'
require 'Module/Bank/Store'
require 'Module/Bank/MultipleEntry'
require 'Module/Bank/SingleEntry'

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
                copy =  BlinkColor[0][3],
                paste = BlinkColor[3][0],
            },
            unselected = NewColor[3][2],
        },
        clear = NewColor[3][0],
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
