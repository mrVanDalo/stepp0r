

function PatternEditorModule:__init_pagination()
    self.zoom         = 1 -- influences grid size
    self.page         = 1 -- page of actual pattern
    self.page_start   = 0  -- line left before first pixel
    self.page_end     = 33 -- line right after last pixel
    self:__create_paginator_update()
end

function PatternEditorModule:__create_paginator_update()
    self.pageinator_update_callback = function (msg)
        self.page       = msg.page
        self.page_start = msg.page_start
        self.page_end   = msg.page_end
        self.zoom       = msg.zoom
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end
