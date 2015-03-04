
function TrackPagination:__init_update_callback()
    self.update_callbacks = {}
end
function TrackPagination:__activate_update_callback()
end
function TrackPagination:__deactivate_update_callback()
end


function Paginator:register_update_callback(callback)
    table.insert(self.update_callbacks, callback)
end

function TrackPagination:_update_callbacks()
    local page = {
        page_offset = self._page_offset,
    }
    for _, callback in ipairs(self.update_callbacks) do
        callback(page)
    end
end
