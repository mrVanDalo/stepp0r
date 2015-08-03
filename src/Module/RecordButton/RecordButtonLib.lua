
function RecordButton:__init_lib()
end
function RecordButton:__activate_lib()
end
function RecordButton:__deactivate_lib()
end


function RecordButton:_toggle_record()
    if Renoise.transport:is_recording() then
        self:__stop_recording()
    else
        self:__start_recording()
    end
end

function RecordButton:_toggle_play()
    if Renoise.transport:is_playing() then
        self:__stop_playing()
    else
        self:__start_playing()
    end
end


function RecordButton:__start_playing()
    renoise.song().transport.playing = true
end

function RecordButton:__stop_playing()
    renoise.song().transport.playing = false
end

function RecordButton:__start_recording()
    renoise.song().transport.follow_player = true
    renoise.song().transport.edit_mode = true
    renoise.app().window.active_middle_frame = renoise.ApplicationWindow.MIDDLE_FRAME_PATTERN_EDITOR
end

function RecordButton:__stop_recording()
    renoise.song().transport.follow_player = false
    renoise.song().transport.edit_mode = false
end
