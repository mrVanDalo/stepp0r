

--- ======================================================================================================
---
---                                                 [ Editor Pagination Sub Module ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Chooser:__init_pagination()
    self:__create_paginator_update()
end
function Chooser:__activate_pagination()
end
function Chooser:__deactivate_pagination()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Editor:__create_paginator_update()
    self.pageinator_update_callback = function (msg)
        --        print("stepper : update paginator")
        self.page       = msg.page
        self.page_start = msg.page_start
        self.page_end   = msg.page_end
        self.zoom       = msg.zoom
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end
