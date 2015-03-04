--- ======================================================================================================
---
---                                                 [ PAGINATION ]

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]
function Chooser:__init_pagination()
    self:__create_track_paginator_update_callback()
end
function Chooser:__activate_pagination()
end
function Chooser:__deactivate_pagination()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Chooser:__create_track_paginator_update_callback()
    self.track_paginator_update_callback = function (page)
        self.inst_offset = page.page_offset
        if self.is_not_active then return end
        self:_update_instrument_row()
    end
end

--- notifier for instrument changes
--
-- there is also another notifier wired to the same event for updating the instruments row
function Chooser:__create_instruments_page_notifier()
end

function Chooser:_update_page_knobs()
end

function Chooser:__clear_page_knobs()
end

function Chooser:__page_inc()
end

function Chooser:__page_dec()
end

