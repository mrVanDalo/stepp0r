--- ======================================================================================================
---
---                                                 [ Instrument and Track Selection Layer ]
---
--- To keep track of instruments, tracks and track column selection.
---
--- more of a on top of Track and Instrument abstraction Layer

TrackData = {
    type = {
        sequencer = renoise.Track.TRACK_TYPE_SEQUENCER,
        master = renoise.Track.TRACK_TYPE_MASTER,
        send = renoise.Track.TRACK_TYPE_SEND,
        group = renoise.Track.TRACK_TYPE_GROUP,
    },
    mute = {
        active = renoise.Track.MUTE_STATE_ACTIVE,
        off = renoise.Track.MUTE_STATE_OFF,
        muted = renoise.Track.MUTE_STATE_MUTED,
    },
}

class "IT_Selection"

require 'Layer/IT_Selection/IT_SelectionTrack'
require 'Layer/IT_Selection/IT_SelectionInstrument'
require 'Layer/IT_Selection/IT_SelectionColumn'


--- ======================================================================================================
---
---                                                 [ INIT ]


function IT_Selection:__init()
    self:_init_track()
    self:_init_instrument()
    self:_init_column()
end



--- boot the layer (basically trigger all listeners)
function IT_Selection:boot()
    self.selected_track_listener()
end





--- ======================================================================================================
---
---                                                 [ boot ]

function IT_Selection:connect()
    self:_connect_track()
end

function IT_Selection:disconnect()
    self:_disconnect_track()
end




