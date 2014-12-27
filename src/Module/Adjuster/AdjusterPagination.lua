
--- ======================================================================================================
---
---                                                 [ Pagination of the Adjuster ]
---


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]

function Adjuster:__init_pagination()
    self:__create_paginator_update()
end

function Adjuster:__activate_pagination()
end

function Adjuster:__deactivate_pagination()
end

function Adjuster:__create_paginator_update()
    self.pageinator_update_callback = function (msg)
        --        print("adjuster : update paginator")
        self.page       = msg.page
        self.page_start = msg.page_start
        self.page_end   = msg.page_end
        self.zoom       = msg.zoom
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end

