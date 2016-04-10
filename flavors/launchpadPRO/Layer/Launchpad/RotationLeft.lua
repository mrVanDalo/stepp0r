function Launchpad:_left_callback(msg)
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
        for _, callback in pairs(self._side_listener) do
            callback(self, result)
        end
        return
    end
end

--- Test functions for the handler
--

function _is_side_left(msg)
    if msg[1] == 0xB0 then
        local x = msg[2] - 91
		local v = Launchpad:getvel(msg[3])
        if (x > -1 and x < 8) then
            return { flag = true,  x = (8 - x), vel = v }
        end
    end
    return LaunchpadData.no
end

function _is_top_left(msg)
    if msg[1] == 0xb0 then
        local x = 8 - math.floor(msg[2] / 10) 
		local v = Launchpad:getvel(msg[3])
        if (x > -1 and x < 8) then
            return { flag = true,  x = (x + 1), vel = v }
        end        
    end
    return LaunchpadData.no
end

function _is_matrix_left(msg)
    if msg[1] == 0x90 then
        local note = msg[2]
        local y = math.floor(note / 10) -1
        local x = note - 10 * (1+y) - 1;      
		local v = Launchpad:getvel(msg[3])
		y = 7 - y

        if ( x > -1 and x < 8 and y > -1  and y < 8 ) then
            return { flag = true , y = 8 - x , x = (y + 1), vel = v }
        end
    end
    return LaunchpadData.no
end



---
-- Set parameters

function Launchpad:_set_matrix_left( a, b , color )
    local y = a - 1
    local x = 8 - b
    if ( x < 8 and x > -1 and y < 8 and y > -1) then
        self:send(0x90 , 81 + x - 10 *y, color)
    end
end

function Launchpad:_set_side_left(a,color)
    local x = 8 - a
    if ( x > -1 and x < 8 ) then
        self:send( 0xB0, x + 91, color)
    end
end

function Launchpad:_set_top_left(a,color)
    local x = a - 1
    if ( x > -1 and x < 8 ) then
        self:send( 0xb0, 89 - 10 * x, color)
    end
end
