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
require 'Layer/IT_Selection/IT_SelectionPattern'
require 'Layer/IT_Selection/IT_SelectionIdle'


--- ======================================================================================================
---
---                                                 [ INIT ]

function IT_Selection:__init()
    self:_init_track()
    self:_init_instrument()
    self:_init_column()
    self:_init_pattern()
    self:_init_idle()
end

--- boot the layer (basically trigger all listeners)
function IT_Selection:boot()
    self:_boot_track()
    self:_boot_pattern()
    self:_boot_idle()
end


--- ======================================================================================================
---
---                                                 [ boot ]

function IT_Selection:connect()
    self:_connect_track()
    self:_connect_pattern()
    self:_connect_idle()
end

function IT_Selection:disconnect()
    self:_disconnect_track()
    self:_disconnect_pattern()
    self:_disconnect_idle()
end




