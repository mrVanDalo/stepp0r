--- ======================================================================================================
---
---                                                 [ Playback Position Observer ]
---
--- observes the playback position to make listeners on the playback position possible

class "PlaybackPositionObserver"

--- ======================================================================================================
---
---                                                 [ INIT ]

function PlaybackPositionObserver:__init()
    self._hooks = {}
end

--- id : a key to find the hook later (to delete it)
--- hook : a function called (with the updated value)
-- todo rename me to renoise lua standard
function PlaybackPositionObserver:register(id,hook)

    if self._hooks[id] then
        self:unregister(id)
    end

    local internal_hook_func = function()
        local current_value = renoise.song().transport.playback_pos
        if current_value ~= self._hooks[id].last_value then
            self._hooks[id].last_value = current_value
            self._hooks[id].external_hook(current_value)
        end
    end

    self._hooks[id] = {
        external_hook = hook,
        internal_hook = internal_hook_func,
        last_value    = renoise.song().transport.playback_pos,
    }

    renoise.tool().app_idle_observable:add_notifier(internal_hook_func)
end

-- todo rename me to renoise lua standard
function PlaybackPositionObserver:unregister(id)
    if self._hooks[id] then
        if renoise.tool().app_idle_observable:has_notifier(self._hooks[id].internal_hook) then
            renoise.tool().app_idle_observable:remove_notifier(self._hooks[id].internal_hook)
        end
        self._hooks[id] = nil
    end
end

function PlaybackPositionObserver:has_notifier(id)
    if self._hooks[id] then
        return true
    else
        return false
    end
end

