
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
        { note.off, note.cis, note.dis, note.off, note.fis, note.gis, note.ais, note.off},
        { note.c  , note.d  , note.e  , note.f  , note.g  , note.a  , note.b  , note.C  },
    }
}

-- register a callback (which gets a note)
-- on notechanges
function KeyboardModule:register_set_note(callback)
    table.insert(self.callback_set_note, callback)
end

function KeyboardModule:unregister_set_note(_)
    print("can't unregister right now")
end


function KeyboardModule:wire_launchpad(pad)
    self.pad = pad
end

-- returns the state of this module to reset it later
function KeyboardModule:state()
    return {
        offset = self.offset,
        note   = self.note,
        octave = self.octave,
    }
end

function KeyboardModule:load_state(state)
    self.offset = state.offset
    self.note   = state.note
    self.octave = state.octave
end

-- callback function
function KeyboardModule:callback_set_instrument()
    local function set_instrument(index)
        -- todo backup old state
        self.instrument = index
        -- todo recover old state of that index
    end
    return set_instrument
end

-- ich brauch einen kontainer über den die
-- Module miteinander reden können
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
    self.note       = note.c
    self.octave     = 4
    self.instrument = 1
    -- callback
    self.callback_set_note = {}
end


function KeyboardModule:_activate()
    self:clear()
    self.pad:set_flash()
    self:_setup_keys()
    self:_setup_callbacks()
    self:_setup_client()
end

function KeyboardModule:clear()
    local y0 = self.offset
    local y1 = self.offset + 1
    for x=1,8,1 do
        self.pad:set_matrix(x,y0,self.pad.color.off)
        self.pad:set_matrix(x,y1,self.pad.color.off)
    end
end

function KeyboardModule:_deactivate()
    self:clear()
    self.pad:unregister_matrix_listener()
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

function KeyboardModule:print_note()
    print(("note : %s%s"):format(self.note[access.label],self.octave))
end

function KeyboardModule:set_note(x,y)
    self.note = keyboard.reverse_mapping[y - self.offset][x]
    self:print_note()
    -- fullfill callbacks
    for _, callback in ipairs(self.callback_set_note) do
        callback(self, self.note)
    end
end

function KeyboardModule:update_keys()
    self:update_notes()
    self:update_octave()
    self:update_active_note()
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

function KeyboardModule:update_octave()
    self.pad:set_matrix(
        self.octave,
        2 + self.offset,
        self.color.octave)
end

function is_not_off(tone) return tone[access.pitch] ~= -1 end
function is_off(tone)     return tone[access.pitch] == -1 end

function KeyboardModule:update_notes()
    for note,tone in pairs(note) do
        if (is_not_off(tone)) then
            self.pad:set_matrix(
            tone[access.x],
            tone[access.y] + self.offset,
            self.color.note)
        else
            self.pad:set_matrix(
            tone[access.x],
            tone[access.y] + self.offset,
            self.color.off)
        end
    end
end


function KeyboardModule:_setup_client()
    --self.client, socket_error = renoise.Socket.create_client( "localhost", 8008, renoise.Socket.PROTOCOL_UDP)
    self.client = renoise.Socket.create_client( "localhost", 8008, renoise.Socket.PROTOCOL_UDP)
end

function KeyboardModule:trigger_note()
    local OscMessage = renoise.Osc.Message
    local track      = self.instrument
    local pitch      = self.note[access.pitch]
    local velocity   = 127
    print(("pitch : %s"):format(pitch))
    if pitch == -1 then
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
            {tag="i",value=(pitch + (self.octave * 12))},
            {tag="i",value=velocity}}))
    end
end

function KeyboardModule:untrigger_note()
    --self.client:send(OscMessage("/renoise/trigger/note_on",{
    print("not yet")
end

function KeyboardModule:update_active_note()
    local x     = self.note[access.x]
    local y     = self.note[access.y] + self.offset
    print(("active note : (%s,%s)"):format(x,y))
    self.pad:set_matrix( x, y, self.color.active_note )
end

