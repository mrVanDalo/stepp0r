--- ======================================================================================================
---
---                                                 [ Pagination  ]
---
--- takes car of pagination


class "Paginator" (Module)

function Paginator:__init()
    Module:__init(self)
    -- pagination
    self.page         = 1 -- page of actual pattern
    self.page_inc_idx = 2
    self.page_dec_idx = 1
    self.page_start   = 0  -- line left before first pixel
    self.page_end     = 33 -- line right after last pixel
    -- zoom
    self.zoom         = 1 -- influences grid size
    self.zoom_out_idx = 7
    self.zoom_in_idx  = 6
    --  init callbacks
    self.update_callbacks = {}
    self:_first_run()
end

function Paginator:_first_run()
    self:__create_pattern_idx_update_callback()
    self:__create_page_listener()
end

function Paginator:wire_launchpad(pad)
    self.pad = pad
end

function Paginator:register_update_callback(callback)
    table.insert(self.update_callbacks, callback)
end

function Paginator:_activate()
    self.pattern_idx = renoise.song().selected_pattern_index
    add_notifier(renoise.song().selected_pattern_index_observable, self.pattern_idx_update_callback)
    self.pad:register_top_listener(self.page_listener)
    self.pad:register_top_listener(self.zoom_listener)
end

function Paginator:_deactivate()
    remove_notifier(renoise.song().selected_pattern_index_observable, self.pattern_idx_update_callback)
    self.pad:unregister_top_listener(self.page_listener)
    self.pad:unregister_top_listener(self.zoom_listener)
end

function Paginator:__create_pattern_idx_update_callback()
    self.pattern_idx_update_callback = function ()
        self.pattern_idx = renoise.song().selected_pattern_index
    end
end

