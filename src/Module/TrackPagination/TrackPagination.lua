
--- ======================================================================================================
---
---                                                 [ Track Pagination  ]
---
---
--- Pagination of the tracks


class "TrackPaginator" (Module)

function TrackPaginator:__init()
    Module:__init(self)
    self.color = {
        page = {
            active   = NewColor[3][2],
            inactive = NewColor[1][1],
        },
    }
    --
    self:__init_launchpad_top()
    self:__init_lib()
    self:__init_update_callback()
end

function TrackPaginator:_activate()
    self:__activate_launchpad_top()
    self:__activate_lib()
    self:__activate_update_callback()
end

function TrackPaginator:_deactivate()
    self:__deactivate_launchpad_top()
    self:__deactivate_update_callback()
    self:__deactivate_lib()
end




