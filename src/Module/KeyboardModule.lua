
require 'Module/LaunchpadModule'
require 'Data/Note'
require 'Data/Color'
require 'Data/Velocity'

--- ======================================================================================================
---
---                                                 [ Keyboard Module ]
---
--- To trigger notes and set notes for a system

class "KeyboardModule" (LaunchpadModule)

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
        self:matrix_refresh()
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
        note = {
            on      = Color.green ,
            active  = Color.flash.orange,
            off     = Color.red,
        },
        octave      = Color.yellow,
        manover     = Color.orange,
        clear       = Color.off,
    }
    self.osc = {
        host = "localhost",
        port = 8008,
    }
    self.note       = Note.note.c
    self.octave     = 4
    self.instrument = 1
    self.instrument_backup = {}
    self.velocity   = 127
    -- callback
    self.callback_set_note = {}
end








--- ======================================================================================================
---
---                                                 [ BOOT ]

function KeyboardModule:_activate()
    self:matrix_refresh()
    self:register_matrix_listener()
    self:setup_osc_client()
end

function KeyboardModule:register_matrix_listener()
    local function matrix_callback(_,msg)
        -- todo optimize me
        if (msg.y > self.offset and msg.y < (self.offset + 3) ) then
            if (msg.vel == Velocity.release) then
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
                self:matrix_update_keys()
            end
        end
    end
    self.pad:register_matrix_listener(matrix_callback)
end


function KeyboardModule:_deactivate()
    self:matrix_clear()
    self.pad:unregister_matrix_listener()
end












--- ======================================================================================================
---
---                                                 [ Library ]

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
    self.note = KeyboardData.reverse_mapping[y - self.offset][x]
    -- fullfill callbacks
    for _, callback in ipairs(self.callback_set_note) do
        callback(self.note, self.octave)
    end
end








--- ======================================================================================================
---
---                                                 [ OSC Client ]

function KeyboardModule:setup_osc_client()
    --self.client, socket_error = renoise.Socket.create_client( "localhost", 8008, renoise.Socket.PROTOCOL_UDP)
    self.client = renoise.Socket.create_client( self.osc.host , self.osc.port,  renoise.Socket.PROTOCOL_UDP)
end

function KeyboardModule:trigger_note()
    local OscMessage = renoise.Osc.Message
    local track      = self.instrument
    if is_not_off(self.note) then
        self.client:send(OscMessage("/renoise/trigger/note_on",{
            {tag="i",value=self.instrument},
            {tag="i",value=track},
            {tag="i",value=pitch(self.note,self.octave)},
            {tag="i",value=self.velocity}}))
    end
end

function KeyboardModule:untrigger_note()
    --self.client:send(OscMessage("/renoise/trigger/note_on",{
    print("not yet")
end










--- ======================================================================================================
---
---                                                 [ Rendering ]

function KeyboardModule:matrix_refresh()
    self:matrix_clear()
    self.pad:set_flash()
    self:matrix_update_keys()
    self:matrix_update_keys_manover()
end

function KeyboardModule:matrix_clear()
    local y0 = self.offset + 1
    local y1 = self.offset + 2
    for x=1,8 do
        self.pad:set_matrix(x,y0,self.color.clear)
        self.pad:set_matrix(x,y1,self.color.clear)
    end
end

function KeyboardModule:matrix_update_keys()
    self:matrix_update_keys_note()
    self:matrix_update_keys_octave()
    self:matrix_update_key_note_active()
end

function KeyboardModule:matrix_update_keys_octave()
    self.pad:set_matrix(
        self.octave,
        2 + self.offset,
        self.color.octave)
end

function KeyboardModule:matrix_update_keys_note()
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

function KeyboardModule:matrix_update_key_note_active()
    local x     = self.note[Note.access.x]
    local y     = self.note[Note.access.y] + self.offset
    self.pad:set_matrix( x, y, self.color.note.active)
end

function KeyboardModule:matrix_update_keys_manover()
    self.pad:set_matrix(
        1,
        1 + self.offset,
        self.color.manover)
    self.pad:set_matrix(
        8,
        1 + self.offset,
        self.color.manover)
end
