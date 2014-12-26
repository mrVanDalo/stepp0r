--- ======================================================================================================
---
---                                                 [ OSC Client ]
---
--- triggers notes via osc on renoise

class "OscClient"

function OscClient:__init()
    self.host = "localhost"
    self.protocol = renoise.Socket.PROTOCOL_UDP
    self.client = nil
end


function OscClient:connect(host, port)
    if self.client then return end
    if not port then return end
    if not host then return end
    self.client = renoise.Socket.create_client(host , port, self.protocol)
end

--- ======================================================================================================
---
---                                                 [ Boot ]

function OscClient:disconnect()
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
function OscClient:trigger_note(instrument_idx, track_idx, note, velocity)
    if not self.client then return end
    self.client:send(renoise.Osc.Message("/renoise/trigger/note_on",{
        {tag="i",value= instrument_idx },
        {tag="i",value=track_idx},
        {tag="i",value=note},
        {tag="i",value=velocity}}))
end

--- mute a note on osc server
-- --------------------------
-- instrument : integer
-- note : integer (use the pitch function from Data/Note)
function OscClient:untrigger_note(instrument_idx, track_idx, note)
    if not self.client then return end
    self.client:send(renoise.Osc.Message("/renoise/trigger/note_off",{
        {tag="i",value= instrument_idx },
        {tag="i",value=track_idx},
        {tag="i",value=note},
    }))
end
