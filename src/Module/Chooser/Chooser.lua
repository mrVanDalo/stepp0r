--- ======================================================================================================
---
---                                                   Chooser Moudle
---
--- To choose instruments/tracks and track rows.
-- todo : rename it to something more obvious

ChooserData =  {
    access = {
        id    = 1,
        color = 2,
    },
    mode = {
        choose = {1, NewColor[3][2]},
        mute   = {2, Color.red},
    },
    color = {
        clear = Color.off, -- todo deprecated ?
        active   = 0,
        inactive = 10,
        mute     = 20,
        unmute   = 50,
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
    self:create_color()

    self:__init_instrument_row()
    self:__init_pagination()
    self:__init_mode()
    self:__init_note_column()
end

function Chooser:create_color()

    self.color = {
        column = {
            active    = NewColor[3][3],
            inactive  = NewColor[1][2],
            invisible = NewColor[0][0],
        },
    }

    local active   = ChooserData.color.active
    local inactive = ChooserData.color.inactive
    local mute     = ChooserData.color.mute
    local unmute   = ChooserData.color.unmute

    self.color.instrument = {}
    self.color.instrument[ mute   + active   ] = BlinkColor[3][0]
    self.color.instrument[ mute   + inactive ] = NewColor[3][0]
    self.color.instrument[ unmute + active   ] = BlinkColor[3][2]
    self.color.instrument[ unmute + inactive ] = NewColor[3][2]

end


function Chooser:_activate()
    self:__activate_pagination()
    self:__activate_mode()
    self:__activate_note_column()
    self:__activate_instrument_row()
end

function Chooser:_deactivate()
    self:__deactivate_pagination()
    self:__deactivate_mode()
    self:__deactivate_note_column()
    self:__deactivate_instrument_row()
end

function Chooser:wire_launchpad(pad)
    self.pad = pad
end

function Chooser:wire_it_selection(selection)
    self.it_selection = selection
end

