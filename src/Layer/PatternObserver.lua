
--- ======================================================================================================
---
---                                                 [ Pattern Observer ]
---
--- A more sensible Selected Pattern Observer than 'selected_pattern_index_observable'

class "PatternObserver"


function PatternObserver:__init()
    self._hooks = {}

    self:__create_selected_index_observer()
    self:__create_alias_pattern_index_observer()
    self:__create_selected_track_index_observer()

end

-- todo just pimp IT_Selection

function PatternObserver:activate()
    add_notifier(renoise.song().selected_pattern_index_observable, self.__selected_pattern_index_observer)
end

function PatternObserver:deactivate()

end

function PatternObserver:__create_selected_index_observer()
    self.__selected_pattern_index_observer = function ()

    end
end

function PatternObserver:__create_alias_pattern_index_observer()

end

function PatternObserver:__create_selected_track_index_observer()

end

--- hook : a function called (with the updated value)
function PatternObserver:register(callback)

    if self._hooks[callback] then
        return
--        self:unregister(callback)
    end





--    local internal_hook_func = function()
--        local current_value = renoise.song().transport.playback_pos
--        if current_value ~= self._hooks[id].last_value then
--            self._hooks[id].last_value = current_value
--            self._hooks[id].external_hook(current_value)
--        end
--    end

--    self._hooks[id] = {
--        external_hook = hook,
--        internal_hook = internal_hook_func,
--        last_value    = renoise.song().transport.playback_pos,
--    }

--    renoise.tool().app_idle_observable:add_notifier(internal_hook_func)
end

function PlaybackPositionObserver:unregister(callback)
--    if self._hooks[id] then
--        if renoise.tool().app_idle_observable:has_notifier(self._hooks[id].internal_hook) then
--            renoise.tool().app_idle_observable:remove_notifier(self._hooks[id].internal_hook)
--        end
--        self._hooks[id] = nil
--    end
end

function PlaybackPositionObserver:has_notifier(id)
    if self._hooks[id] then
        return true
    else
        return false
    end
end
