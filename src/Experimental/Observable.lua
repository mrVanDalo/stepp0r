--------------------------------------------------------------------------------
-- Observer class
--
-- makes unobservable values observable, using app_idle_observable
--
-- functions:
--
--  add_notifier(Function hook, String observed)
--    example:
--      my_instance:add_notifier(function(value) my_hook(value) end,
--        "renoise.song().transport.loop_block_range_coeff")
--
--  remove_notifier(Function hook)
--
--  has_notifier(Function hook)
--------------------------------------------------------------------------------

class "Observer"

function Observer:__init()
    self._hooks = {}
end

function Observer:add_notifier(hook, observed_arg)
    assert(hook, "hook not defined or invalid")
    assert(type(hook) == "function", "expected hook to be a function")
    assert(observed_arg, "observed value not defined or invalid")
    assert(type(observed_arg) == "string", "expected observed value to be a string")

    local function get_value()
        local return_value = loadstring("return "..observed_arg)
        local current_value = nil
        pcall(function()
            current_value = return_value()
        end)

        return current_value
    end

    local internal_hook_func = function()
        local current_value = get_value()
        if current_value ~= self._hooks[hook].last_value then
            self._hooks[hook].last_value = current_value
            self._hooks[hook].external_hook(current_value)
        end
    end

    self._hooks[hook] = {
        external_hook = hook,
        internal_hook = internal_hook_func,
        last_value = get_value(),
    }

    renoise.tool().app_idle_observable:add_notifier(internal_hook_func)
end


function Observer:remove_notifier(hook)
    assert(hook, "hook not defined or invalid")
    assert(self._hooks[hook], "no such hook registered")
    assert(type(hook) == "function", "expected hook to be a function")

    renoise.tool().app_idle_observable:remove_notifier(self._hooks[hook].internal_hook)
    self._hooks[hook] = nil
end

function Observer:has_notifier(hook)
    assert(hook, "hook not defined or invalid")
    assert(type(hook) == "function", "expected hook to be a function")

    if self._hooks[hook] then
        return true
    else
        return false
    end
end