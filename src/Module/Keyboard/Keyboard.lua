--- ======================================================================================================
---
---                                                 [ Keyboard Module ]
---
--- To trigger notes and set notes for a system

class "Keyboard" (Module)

require "Module/Keyboard/KeyboardTrigger"
require "Module/Keyboard/KeyboardLaunchpadMatrix"
require "Module/Keyboard/KeyboardInstrumentCallback"
require "Module/Keyboard/KeyboardSetNoteCallback"


--- this is a strange y -> x map for notes
KeyboardData = {
    reverse_mapping = {
        { Note.note.off, Note.note.cis, Note.note.dis, Note.note.off, Note.note.fis, Note.note.gis, Note.note.ais, Note.note.off},
        { Note.note.c  , Note.note.d  , Note.note.e  , Note.note.f  , Note.note.g  , Note.note.a  , Note.note.b  , Note.note.C  },
    }
}


--- ======================================================================================================
---
---                                                 [ INIT ]

--- register a callback (which gets a note)
--
function Keyboard:register_set_note(callback)
    table.insert(self.callback_set_note, callback)
end


function Keyboard:wire_launchpad(pad)
    if self.is_active then return end
    self.pad = pad
end

function Keyboard:wire_osc_client(client)
    self.osc_client = client
end

function Keyboard:__init()
    Module:__init(self)

    self.offset = 6

    -- default
    self.color = {
        note = {
            on      = NewColor[3][3],
            active  = BlinkColor[0][3],
            off     = NewColor[3][0],
        },
        octave      = NewColor[3][1],
        manover     = NewColor[3][1],
        clear       = NewColor[0][0],
    }

    self.note       = Note.note.c

    self:__init_keyboard_trigger()
    self:__init_keyboard_matrix()
    self:__init_keyboard_instrument_callback()
    self:__init_keyboard_set_note()
end

function Keyboard:_activate()
    self:__activate_keyboard_trigger()
    self:__activate_keyboard_matrix()
    self:__activate_keyboard_instrument_callback()
    self:__activate_keyboard_set_note()
    self:matrix_refresh()
end

function Keyboard:_deactivate()
    self:__deactivate_keyboard_trigger()
    self:__deactivate_keyboard_matrix()
    self:__deactivate_keyboard_instrument_callback()
    self:__deactivate_keyboard_set_note()
    self:matrix_clear()
end

--- ======================================================================================================
---
---                                                 [ Rendering ]

function Keyboard:matrix_refresh()
    self:matrix_clear()
    self.pad:set_flash()
    self:_update_matrix_keys()
    self:_update_manover_keys()
end

function Keyboard:matrix_clear()
    local y0 = self.offset + 1
    local y1 = self.offset + 2
    for x=1,8 do
        self.pad:set_matrix(x,y0,self.color.clear)
        self.pad:set_matrix(x,y1,self.color.clear)
    end
end

function Keyboard:_update_matrix_keys()
    self:_update_note_key()
    self:_update_active_note_key()
    self:_update_octave_key()
end

function Keyboard:_update_octave_key()
    self.pad:set_matrix(
        self.octave,
        2 + self.offset,
        self.color.octave)
end

function Keyboard:_update_note_key()
    for _,tone in pairs(Note.note) do
        if (is_not_off(tone)) then
            self.pad:set_matrix(
                tone[Note.access.x],
                tone[Note.access.y] + self.offset,
                self.color.note.on)
        else
            self.pad:set_matrix(
                tone[Note.access.x],
                tone[Note.access.y] + self.offset,
                self.color.note.off)
        end
    end
end

function Keyboard:_update_active_note_key()
    local x     = self.note[Note.access.x]
    local y     = self.note[Note.access.y] + self.offset
    self.pad:set_matrix( x, y, self.color.note.active)
end

function Keyboard:_update_manover_keys()
    self.pad:set_matrix(
        1,
        1 + self.offset,
        self.color.manover)
    self.pad:set_matrix(
        8,
        1 + self.offset,
        self.color.manover)
end
