--- ======================================================================================================
---
---                                                 [ Mode ]
---
--- to group Modules and activate and deactivate them


class "Mode" (Module)


function Mode:__init()
    Module:__init(self)
    self.table = {}
    self.mode     = 0
    self:__create_mode_update_callback()
end


function Mode:__create_mode_update_callback()
    self.mode_update_callback = function (mode)
        self:__deactivate_mode()
        self.mode = mode
        self:__activate_mode()
    end
end

function Mode:add_module_to_mode(mode, module)
    if not self.table[mode] then
        self.table[mode] = {}
    end
    table.insert(self.table[mode], module)
end

-- module must contain function :register_mode_update :unregister_mode_update
function Mode:wire_toggle_module(module)
    self.module = module
end

function Mode:_activate()
    if self.module then
        self.module:register_module_update(self.module_update_callback)
    end
    self:__activate_mode()
end

function Mode:_deactivate()
    if self.module then
        self.module:unregister_mode_update(self.mode_update_callback)
    end
    self:__deactivate_mode()
end


function Mode:__activate_mode()
    if not self.table[self.mode] then return end
    local modules = self.table[self.mode]
    for _, module in ipairs(modules) do
        module:activate()
    end
end

function Mode:__deactivate_mode()
    if not self.table[self.mode] then return end
    local modules = self.table[self.mode]
    for _, module in ipairs(modules) do
        module:deactivate()
    end

end
