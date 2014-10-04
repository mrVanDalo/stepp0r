
--- ======================================================================================================
---
---                                                 [ OSC Client ]
---
--- triggers notes via osc on renoise

class "OscClient"

function OscClient:__init()
    self.host = "localhost"
    self.port = 8008
    self.protocol = renoise.Socket.PROTOCOL_UDP
    self.client = nil
end

function OscClient:set_host(host)
    if not host then return end
    self.host = host
end

function OscClient:set_port(port)
    if not port then return end
    self.port = port
end


--- ======================================================================================================
---
---                                                 [ Boot ]



function OscClient:start()
    self.client = renoise.Socket.create_client(self.host , self.port, self.protocol)
end

function OscClient:tear_down()
    if not self.client then return end
    self.client:close()
    self.client = nil
end


--- ======================================================================================================
---
---                                                 [ Commands ]

--- send note to osc
-- -----------------
-- instrument : number of instrument (integer)
-- note : integer (use the pitch function from Data/Note)
-- velocity : integer
function OscClient:trigger_note(instrument, note, velocity)
    if not self.client then return end
    local track       = instrument
    self.client:send(renoise.Osc.Message("/renoise/trigger/note_on",{
        {tag="i",value=instrument},
        {tag="i",value=track},
        {tag="i",value=note},
        {tag="i",value=velocity}}))
end

--- mute a note on osc server
-- --------------------------
-- instrument : integer
-- note : integer (use the pitch function from Data/Note)
function OscClient:untrigger_note(instrument, note)
    if not self.client then return end
    local track = instrument
    self.client:send(renoise.Osc.Message("/renoise/trigger/note_off",{
        {tag="i",value=instrument},
        {tag="i",value=track},
        {tag="i",value=note},
    }))
end
