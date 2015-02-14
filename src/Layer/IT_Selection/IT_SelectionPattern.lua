

function IT_Selection:_init_pattern()
    self.pattern_idx = 1
    self.callback_select_pattern = {}
end


function IT_Selection:_connect_pattern()

end

--- register callback
--
-- the callback gets the `index of pattern`
function IT_Selection:register_select_instrument(callback)
    table.insert(self.callback_select_pattern, callback)
end

-- function :callback_set_instrument() return function(instrument_idx, track_idx, column_idx) end end
function IT_Selection:__update_set_pattern_listeners()
    --    log("instrument_idx", self.instrument_idx)
    --    log("track_idx", self.track_idx)
    --    log("column_idx", self.column_idx)
    for _, callback in ipairs(self.callback_select_pattern) do
        callback(self.pattern_idx)
    end
end
