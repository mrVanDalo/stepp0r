--- ======================================================================================================
---
---                                                 [ Paginator ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


--function Paginator:__init_paging()
--end
--function Paginator:__activate_paging()
--end
--function Paginator:__deactivate_paging()
--end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

--- get the active pattern object
--
-- self.pattern_idx will be kept up to date by an observable notifier
--
function Paginator:_active_pattern()
    return renoise.song().patterns[self.pattern_idx]
end

function Paginator:_update_listeners()
    local page = {
        page       = self.page,
        page_start = self.page_start,
        page_end   = self.page_end,
        zoom       = self.zoom,
    }
--    print("update listeners")
--    print("----------------")
--    print("page       ".. self.page)
--    print("page_start ".. self.page_start)
--    print("page_end   ".. self.page_end)
--    print("zoom       ".. self.zoom)
    for _, callback in ipairs(self.update_callbacks) do
        callback(page)
    end
end
