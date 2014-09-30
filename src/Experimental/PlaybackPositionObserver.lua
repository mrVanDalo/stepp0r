--
-- User: palo
-- Date: 7/7/14
--

-- require 'Experimental/Observable'


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
    self.observer   = InternalObserver()
end

--- register a function that gets the value
function PlaybackPositionObserver:register(f)
    -- self.observer:add_notifier(f,"renoise.song().transport.playback_pos")
    self.observer:add_notifier('foo',f)
end

function PlaybackPositionObserver:unregister(_)
    self.observer:remove_notifier('foo')
end



class "InternalObserver"

function InternalObserver:__init()
    self._hooks = {}
end

function InternalObserver:add_notifier(id, hook)

    if self._hooks[id] then
        self:remove_notifier(id)
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


function InternalObserver:remove_notifier(id)
    if self._hooks[id] then
        if renoise.tool().app_idle_observable:has_notifier(self._hooks[id].internal_hook) then
            renoise.tool().app_idle_observable:remove_notifier(self._hooks[id].internal_hook)
        end
        self._hooks[id] = nil
    end
end

function InternalObserver:has_notifier(id)
    if self._hooks[id] then
        return true
    else
        return false
    end
end
