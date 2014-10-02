
require 'Module/Module'
require 'Data/Note'
require 'Data/Color'
require 'Data/Velocity'

--- ======================================================================================================
---
---                                                 [ Keyboard Module ]
---
--- To trigger notes and set notes for a system

class "Keyboard" (Module)

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

function Keyboard:callback_set_instrument()
    return function (index,_)
        if self.is_not_active then return end
        -- save
        self.instrument_backup[self.instrument] = self:state()
        -- switch
        self.instrument = index
        -- load
        local newState = self.instrument_backup[self.instrument]
        if newState then self:load_state(newState) end
        -- refresh
        self:matrix_refresh()
    end
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
    self.instrument = 1
    self.instrument_backup = {}
    self.velocity   = 127
    self.triggered_notes = {
        {nil,nil, nil, nil, nil, nil, nil, nil },
        {nil,nil, nil, nil, nil, nil, nil, nil }
    }
    -- callback
    self.callback_set_note = {}
end








--- ======================================================================================================
---
---                                                 [ BOOT ]

function Keyboard:_activate()
    self:matrix_refresh()
    if self.is_first_run then
        self:setup_matrix_listener()
    end
end

function Keyboard:setup_matrix_listener()
    self.pad:register_matrix_listener(function (_,msg)
        -- precondition
        if self.is_not_active        then return end
        if msg.y <= self.offset      then return  end
        if msg.y > (self.offset + 2) then return end
        -- scale to the keyboard
        local x = msg.x
        local y = msg.y - self.offset
        -- react on signal
        if (msg.vel == Velocity.release) then
            self:untrigger_note(x,y)
        elseif (y == 2) then
            -- second line notes only
            self:set_note(x, y)
            self:trigger_note(x,y)
        elseif (x == 1) then
            self:octave_down()
        elseif (x == 8) then
            self:octave_up()
        else
            self:set_note(x, y)
            self:trigger_note(x,y)
        end
        self:matrix_update_keys()
    end)
end


function Keyboard:_deactivate()
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
---                                                 [ OSC Client ]

function Keyboard:trigger_note(x,y)
    if is_not_off(self.note) then
        local note = pitch(self.note,self.octave)
        self.triggered_notes[y][x] = note
        self.osc_client:trigger_note(self.instrument, note, self.velocity)
    end
end

function Keyboard:untrigger_note(x,y)
    local note = self.triggered_notes[y][x]
    if not note then return end
    self.osc_client:untrigger_note(self.instrument, note)
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
