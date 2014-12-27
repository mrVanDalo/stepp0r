--- ======================================================================================================
---
---                                                   Chooser Moudle
---
--- To choose instruments, tracks and track rows.

ChooserData =  {
    access = {
        id    = 1,
        color = 2,
    },
    mode = {
        choose = {1, Color.yellow},
        mute   = {2, Color.red},
    },
    color = {
        clear = Color.off,
    },
}

-- A class to choose the Instruments
class "Chooser" (Module)

require "Module/Chooser/ChooserNoteColumn"
require "Module/Chooser/ChooserPagination"
require "Module/Chooser/ChooserMode"
require "Module/Chooser/ChooserInstrumentRow"




--- ======================================================================================================
---
---                                                 [ INIT ]


function Chooser:__init()
    Module:__init(self)
    self.instrument_idx = 1
    self.track_idx      = 1
    self.row            = 6
    self.color = {
        instrument = {
            active  = Color.flash.green,
            passive = Color.green,
        },
        mute = {
            active  = Color.flash.red,
            passive = Color.red,
        },
        page = {
            active   = Color.yellow,
            inactive = Color.off,
        },
        column = {
            active    = Color.yellow,
            inactive  = Color.dim.green,
            invisible = Color.off,
        },
    }
    -- callbacks
    self.callback_select_instrument = {}

    self:__init_pagination()
    self:__init_mode()
    self:__init_instrument_row()
end

function Chooser:wire_launchpad(pad)
    self.pad = pad
end

function Chooser:wire_it_selection(selection)
    self.it_selection = selection
end


--- ======================================================================================================
---
---                                                 [ boot ]

function Chooser:_activate()
    self:__activate_pagination()
    self:__activate_mode()
    self:__activate_instrument_row()
end



function Chooser:_deactivate()
    self:__deactivate_pagination()
    self:__deactivate_mode()
    self:__deactivate_instrument_row()
end



