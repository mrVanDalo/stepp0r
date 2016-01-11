--- ======================================================================================================
---
---                                                 [ Bank Module ]
-- to store Copy paste Pattern

class "Bank" (Module)

require 'Module/Bank/LaunchpadUI'
require 'Module/Bank/Store'
require 'Module/Bank/Entry/Entry'
require 'Module/Bank/Entry/MultipleEntry'
require 'Module/Bank/Entry/SingleEntry'

Bank.color = {
    single = {
        clear      = NewColor[3][0],
        copy       = BlinkColor[0][3],
        paste      = BlinkColor[3][0],
        unselected = NewColor[3][2],
    },
    multi = {
        clear      = NewColor[0][3],
        copy       = BlinkColor[0][3],
        paste      = BlinkColor[3][0],
        unselected = NewColor[3][2],
    },
}

function Bank:__init()
    Module:__init(self)

    self.offset = 6

    self.banks    = {}
    self.bank_idx = 1 -- active bank right now
    self.mode     = CopyPasteStore.COPY_MODE

    self.pad = nil

    self:__init_matrix()

end


function Bank:_activate()
    self:__activate_matrix()
    self:_render_matrix()
end

function Bank:_deactivate()
    self:__deactivate_matrix()
    self:_clear_matrix()
end

function Bank:wire_launchpad(pad)
    self.pad = pad
end
function Bank:wire_store(store)
    self.store = store
end
