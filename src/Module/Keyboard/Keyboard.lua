--- ======================================================================================================
---
---                                                 [ Keyboard Module ]
---
--- To trigger notes and set notes for a system

class "Keyboard" (Module)

require "Module/Keyboard/KeyboardTrigger"
require "Module/Keyboard/KeyboardLaunchpadMatrix"
require "Module/Keyboard/KeyboardInstrumentCallback"


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
            on      = Color.green ,
            active  = Color.flash.orange,
            off     = Color.red,
        },
        octave      = Color.yellow,
        manover     = Color.orange,
        clear       = Color.off,
    }
    self.osc_client = nil
    self.note       = Note.note.c
    self.octave     = 4
    self.instrument_idx = 1
    self.track_idx      = 1
    self.instrument_backup = {}
    self.velocity   = 127

    self:__init_keyboard_trigger()
    self:__init_keyboard_matrix()
    self:__init_keyboard_instrument_callback()

    -- callback
    self.callback_set_note = {}

end

function Keyboard:_activate()
    self:__activate_keyboard_trigger()
    self:__activate_keyboard_matrix()
    self:__activate_keyboard_instrument_callback()
    self:matrix_refresh()
end

function Keyboard:_deactivate()
    self:__deactivate_keyboard_trigger()
    self:__deactivate_keyboard_matrix()
    self:__deactivate_keyboard_instrument_callback()
    self:matrix_clear()
end





--- ======================================================================================================
---
---                                                 [ Library ]

--- save and load state
--
function Keyboard:state()
    return {
        note   = self.note,
        octave = self.octave,
    }
end
function Keyboard:load_state(state)
    self.note   = state.note
    self.octave = state.octave
end


--- octave arithmetics
--
function Keyboard:octave_down()
    if (self.octave > 1) then
        self.octave = self.octave - 1
    end
end
function Keyboard:octave_up()
    if (self.octave < 8) then
        self.octave = self.octave + 1
    end
end


--- note arithmetics
-- x and y are relative to the keyboard, not on the matrix!
function Keyboard:set_note(x,y)
    self.note = KeyboardData.reverse_mapping[y][x]
    -- fullfill callbacks
    for _, callback in ipairs(self.callback_set_note) do
        callback(self.note, self.octave)
    end
end











--- ======================================================================================================
---
---                                                 [ Rendering ]

function Keyboard:matrix_refresh()
    self:matrix_clear()
    self.pad:set_flash()
    self:matrix_update_keys()
    self:matrix_update_keys_manover()
end

function Keyboard:matrix_clear()
    local y0 = self.offset + 1
    local y1 = self.offset + 2
    for x=1,8 do
        self.pad:set_matrix(x,y0,self.color.clear)
        self.pad:set_matrix(x,y1,self.color.clear)
    end
end

function Keyboard:matrix_update_keys()
    self:matrix_update_keys_note()
    self:matrix_update_keys_octave()
    self:matrix_update_key_note_active()
end

function Keyboard:matrix_update_keys_octave()
    self.pad:set_matrix(
        self.octave,
        2 + self.offset,
        self.color.octave)
end

function Keyboard:matrix_update_keys_note()
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

function Keyboard:matrix_update_key_note_active()
    local x     = self.note[Note.access.x]
    local y     = self.note[Note.access.y] + self.offset
    self.pad:set_matrix( x, y, self.color.note.active)
end

function Keyboard:matrix_update_keys_manover()
    self.pad:set_matrix(
        1,
        1 + self.offset,
        self.color.manover)
    self.pad:set_matrix(
        8,
        1 + self.offset,
        self.color.manover)
end
