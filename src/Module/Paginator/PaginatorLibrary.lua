


--- get the active pattern object
--
-- self.pattern_idx will be kept up to date by an observable notifier
--
function Adjuster:_active_pattern()
    return renoise.song().patterns[self.pattern_idx]
end

function Adjuster:_update_listeners()
    local page = {
        page       = self.page,
        page_start = self.page_start,
        page_end   = self.page_end,
        zoom       = self.zoom,
    }
    for _, callback in self.update_callbacks do
        callback(page)
    end
end
