function left_callback(msg)
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
