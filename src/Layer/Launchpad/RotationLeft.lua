function Launchpad:left_callback(msg)
    local result = _is_matrix_left(msg)
    if (result.flag) then
        for _, callback in pairs(self._matrix_listener) do
            callback(self, result)
        end
        return
    end
    --
    result = _is_top_left(msg)
    if (result.flag) then
        for _, callback in pairs(self._top_listener) do
            callback(self, result)
        end
        return
    end
    --
    result = _is_side_left(msg)
    if (result.flag) then
        for _, callback in pairs(self._right_listener) do
            callback(self, result)
        end
        return
    end
end

--- Test functions for the handler
--

function _is_side_left(msg)
    if msg[1] == 0xB0 then
        local x = msg[2] - 0x68
        if (x > -1 and x < 8) then
            return { flag = true,  x = 8 - (x + 1), vel = msg[3] }
        end
    end
    return LaunchpadData.no
end
function _is_top_left(msg)
    if msg[1] == 0x90 then
        local note = msg[2]
        if (bit.band(0x08,note) == 0x08) then
            local x = bit.rshift(note,4)
            if (x > -1 and x < 8) then
                return { flag = true,  x = (x + 1), vel = msg[3] }
            end
        end
    end
    return LaunchpadData.no
end
function _is_matrix_right(msg)
    if msg[1] == 0x90 then
        local note = msg[2]
        if (bit.band(0x08,note) == 0) then
            local y = bit.rshift(note,4)
            local x = bit.band(0x07,note)
            if ( x > -1 and x < 8 and y > -1  and y < 8 ) then
                return { flag = true , x = (x + 1) , y = (y + 1), vel = msg[3] }
            end
        end
    end
    return LaunchpadData.no
end
