--- ======================================================================================================
---
---                                                 [ Pagination  ]
---
--- takes car of pagination


class "Paginator" (Module)

require "Module/Paginator/PaginatorUpdateCallback"
require "Module/Paginator/PaginatorPaging"
require "Module/Paginator/PaginatorZooming"

function Paginator:__init()
    Module:__init(self)
    self.color = {
        page = {
            active   = Color.yellow,
            inactive = Color.off,
        },
        zoom = {
            active   = Color.yellow,
            inactive = Color.off,
        },
    }

    self:__init_paging()
    self:__init_zoom()
    self:__init_update_callback()
end

function Paginator:_activate()
    self:__activate_update_callback()
    self:__activate_zoom()
    self:__activate_paging()
end

function Paginator:_deactivate()
    self:__deactivate_paging()
    self:__deactivate_zoom()
    self:__deactivate_update_callback()
end

function Paginator:wire_launchpad(pad)
    self.pad = pad
end




