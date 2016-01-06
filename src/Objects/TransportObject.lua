


class 'TransportObject'

function TransportObject:__init() end



--- Playing

function TransportObject:toggle_playing()
    if self:is_playing() then
        self:stop_playing()
    else
        self:start_playing()
    end
end

function TransportObject:is_playing()
    return renoise.song().transport.playing
end

function TransportObject:start_playing()
    renoise.song().transport.playing = true
    renoise.song().transport.follow_player = true
end

function TransportObject:stop_playing()
    renoise.song().transport.follow_player = false
    renoise.song().transport.playing = false
end






--- Recording

function TransportObject:toggle_recording()
    if self:is_recording() then
        self:stop_recording()
    else
        self:start_recording()
    end
end

function TransportObject:is_recording()
    return renoise.song().transport.edit_mode
end

function TransportObject:start_recording()
    renoise.song().transport.edit_mode = true
    renoise.app().window.active_middle_frame = renoise.ApplicationWindow.MIDDLE_FRAME_PATTERN_EDITOR
end

function TransportObject:stop_recording()
    renoise.song().transport.edit_mode = false
end
