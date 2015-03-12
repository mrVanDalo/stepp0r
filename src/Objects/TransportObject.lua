


class 'TransportObject'


function TransportObject:__init() end

function TransportObject:is_recording()
    return renoise.song().transport.edit_mode
end

function TransportObject:is_playing()
    return renoise.song().transport.playing
end