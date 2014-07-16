
require 'Module/LaunchpadModule'
require 'Data/Note'
require 'Data/Color'

-- --
-- Keyboard Module
--
class "KeyboardModule" (LaunchpadModule)

-- this is a strange y -> x map for notes
keyboard = {
    reverse_mapping = {
        { Note.note.off, Note.note.cis, Note.note.dis, Note.note.off, Note.note.fis, Note.note.gis, Note.note.ais, Note.note.off},
        { Note.note.c  , Note.note.d  , Note.note.e  , Note.note.f  , Note.note.g  , Note.note.a  , Note.note.b  , Note.note.C  },
    }
}

---
------------------------------------------------------------------ init
---

--- register a callback (which gets a note)
--
function KeyboardModule:register_set_note(callback)
    table.insert(self.callback_set_note, callback)
end

function KeyboardModule:unregister_set_note(_)
    print("can't unregister right now")
end

function KeyboardModule:callback_set_instrument()
    local function set_instrument(index,_)
        -- backup
        self.instrument_backup[self.instrument] = self:state()
        -- switch
        self.instrument = index
        -- load backup
        local newState = self.instrument_backup[self.instrument]
        if(newState) then
            self:load_state(newState)
        end
        -- refresh
        self:_refresh()
    end
    return set_instrument
end


function KeyboardModule:wire_launchpad(pad)
    self.pad = pad
end

function KeyboardModule:__init()
    LaunchpadModule:__init(self)
    self.offset = 6
    -- default
    self.color = {
        note        = color.green ,
        active_note = color.flash.orange,
        octave      = color.yellow,
        off         = color.red,
        manover     = color.orange,
    }
    self.note       = Note.note.c
    self.octave     = 4
    self.instrument = 1
    self.instrument_backup = {}
    -- callback
    self.callback_set_note = {}
end

---
------------------------------------------------------------------ boot
---

function KeyboardModule:_activate()
    self:clear()
    self.pad:set_flash()
    self:_setup_keys()
    self:_setup_callbacks()
    self:_setup_client()
    -- todo use refresh
end

function KeyboardModule:_setup_callbacks()
    local function matrix_callback(_,msg)
        -- local press   = 0x7F
        local release = 0x00
        if (msg.y > self.offset and msg.y < (self.offset + 3) ) then
            if (msg.vel == release) then
                self:untrigger_note()
            else
                if (msg.y == 2 + self.offset ) then
                    -- notes only
                    self:set_note(msg.x, msg.y)
                    self:trigger_note()
                else
                    if (msg.x == 1) then
                        self:octave_down()
                    elseif (msg.x == 8) then
                        self:octave_up()
                    else
                        self:set_note(msg.x, msg.y)
                        self:trigger_note()
                    end
                end
                self:update_keys()
            end
        end
    end
    self.pad:register_matrix_listener(matrix_callback)
end

function KeyboardModule:_setup_keys()
    self:update_keys()
    -- manover buttons
    self.pad:set_matrix(
        1,
        1 + self.offset,
        self.color.manover)
    self.pad:set_matrix(
        8,
        1 + self.offset,
        self.color.manover)
end

function KeyboardModule:_setup_client()
    --self.client, socket_error = renoise.Socket.create_client( "localhost", 8008, renoise.Socket.PROTOCOL_UDP)
    self.client = renoise.Socket.create_client( "localhost", 8008, renoise.Socket.PROTOCOL_UDP)
end

function KeyboardModule:_deactivate()
    self:clear()
    self.pad:unregister_matrix_listener()
end


---
------------------------------------------------------------------ library
---

--- save and load state
--
function KeyboardModule:state()
    return {
        note   = self.note,
        octave = self.octave,
    }
end
function KeyboardModule:load_state(state)
    self.note   = state.note
    self.octave = state.octave
end


--- octave arithmetics
--
function KeyboardModule:octave_down()
    if (self.octave > 1) then
        self.octave = self.octave - 1
    end
end
function KeyboardModule:octave_up()
    if (self.octave < 8) then
        self.octave = self.octave + 1
    end
end


--- note arithmetics
--
function KeyboardModule:set_note(x,y)
    self.note = keyboard.reverse_mapping[y - self.offset][x]
    --- self:print_note()
    -- fullfill callbacks
    for _, callback in ipairs(self.callback_set_note) do
        callback(self.note, self.octave)
    end
end




---
------------------------------------------------------------------ osc client
---


function KeyboardModule:trigger_note()
    local OscMessage = renoise.Osc.Message
    local track      = self.instrument
    local tone       = self.note[Note.access.pitch]
    local velocity   = 127
    if tone == -1 then
        -- todo make this turn of the notes
        self.client:send(OscMessage("/renoise/trigger/note_off",{
            {tag="i",value=self.instrument},
            {tag="i",value=track},
            {tag="i",value=-1},
            }))
    else
        -- self.client, socket_error = renoise.Socket.create_client( "localhost", 8008, renoise.Socket.PROTOCOL_UDP)
        self.client:send(OscMessage("/renoise/trigger/note_on",{
            {tag="i",value=self.instrument},
            {tag="i",value=track},
            {tag="i",value=pitch(self.note,self.octave)},
            {tag="i",value=velocity}}))
    end
end

function KeyboardModule:untrigger_note()
    --self.client:send(OscMessage("/renoise/trigger/note_on",{
    print("not yet")
end

---
------------------------------------------------------------------ rendering
---

function KeyboardModule:update_active_note()
    local x     = self.note[Note.access.x]
    local y     = self.note[Note.access.y] + self.offset
    print(("active note : (%s,%s)"):format(x,y))
    self.pad:set_matrix( x, y, self.color.active_note )
end

function KeyboardModule:_refresh()
    self:clear()
    self.pad:set_flash()
    self:_setup_keys()
end

function KeyboardModule:clear()
    local y0 = self.offset + 1
    local y1 = self.offset + 2
    for x=1,8,1 do
        self.pad:set_matrix(x,y0,self.pad.color.off)
        self.pad:set_matrix(x,y1,self.pad.color.off)
    end
end

function KeyboardModule:update_keys()
    self:update_notes()
    self:update_octave()
    self:update_active_note()
end

function KeyboardModule:update_octave()
    self.pad:set_matrix(
        self.octave,
        2 + self.offset,
        self.color.octave)
end

function KeyboardModule:update_notes()
    for _,tone in pairs(Note.note) do
        if (is_not_off(tone)) then
            self.pad:set_matrix(
                tone[Note.access.x],
                tone[Note.access.y] + self.offset,
                self.color.note)
        else
            self.pad:set_matrix(
                tone[Note.access.x],
                tone[Note.access.y] + self.offset,
                self.color.off)
        end
    end
end

