--- ======================================================================================================
---
---                                                 [ Pattern Mix Module ]
---
---
--- keeps track on the mix patterns (and updates the other one)
--- Mix patterns are the (one or two or zero patterns on top of the pattern list) which are used to mix
--- stuff together
--
-- todo : this is a Layer like IT_Selection

class "PatternMix" (Module)

require 'Module/PatternMix/PatternMixCurrentAndNext'
require 'Module/PatternMix/PatternMixArea'

PatternMixData = {
    row = {
        mix_1 = "__stepp0r_mix_1",
        mix_2 = "__stepp0r_mix_2"
    },
}

function PatternMix:__init()
    self:__init_current_and_next()
    self:__init_area()
    --
    self.__update_callbacks         = {}
    --
    self:__create_selected_pattern_idx_listener()
    self:__create_callback_set_instrument()
end

function PatternMix:_activate()
    self:__activate_area()
    self:__activate_current_and_next()

    -- fixme : this will not trigger when there is only one pattern mix sequence
    add_notifier(renoise.song().selected_pattern_index_observable, self.__selected_pattern_idx_listener)
    self:_update_callbacks()
end

function PatternMix:_deactivate()
    self:__deactivate_current_and_next()
    self:__deactivate_area()
    remove_notifier(renoise.song().selected_pattern_index_observable, self.__selected_pattern_idx_listener)
end


function PatternMix:__create_selected_pattern_idx_listener()
    self.__selected_pattern_idx_listener = function ()
        self:_set_active_and_next_patterns()
        if self.is_not_active then return end
        self:__adjuster_next_pattern()
        self:_update_callbacks()
    end
end





function PatternMix:__adjuster_next_pattern()
    print("adjust next pattern")
    for _,track_idx in pairs(Renoise.track:list_idx()) do
        local pattern_idx = Renoise.pattern_matrix:alias_idx(self.active_mix_pattern, track_idx)
        self:set_next(track_idx, pattern_idx)
    end
end

--- set next pattern to show up
function PatternMix:set_next(track_idx, pattern_idx)
    print("called PatternMix:set_next(" .. track_idx .. ", " .. pattern_idx .. ")")
    -- get pattern
    local mix_pattern = self.next_mix_pattern
    if not mix_pattern then return end
    -- get track
    local track = mix_pattern.tracks[track_idx]
    if not track then return end
    -- set alias
    if pattern_idx == -1 then
        -- use default pattern
        local default_idx = renoise.song().sequencer:pattern(self.number_of_mix_patterns + 1)
        track.alias_pattern_index = default_idx
    else
        track.alias_pattern_index = pattern_idx
    end
end

function PatternMix:register_update_callback(callback)
    table.insert(self.__update_callbacks, callback)
end
function PatternMix:_update_callbacks()
    local sequence_idx_blacklist = {}
    if self.pattern_mix_1_sequence_idx then
        table.insert(sequence_idx_blacklist, self.pattern_mix_1_sequence_idx)
    end
    if self.pattern_mix_2_sequence_idx then
        table.insert(sequence_idx_blacklist, self.pattern_mix_2_sequence_idx)
    end
    local update = {
        active                 = self.active_mix_pattern,
        next                   = self.next_mix_pattern,
        sequence_idx_blacklist = sequence_idx_blacklist
    }
    for _, callback in ipairs(self.__update_callbacks) do
        callback(update)
    end
end

function PatternMix:__create_callback_set_instrument()
    self.callback_set_instrument =  function (instrument_idx, track_idx, column_idx)
        -- make sure there is always a pattern set for an instrument
        if self.active_mix_pattern and track_idx then
            local alias = Renoise.pattern_matrix:alias_idx( self.active_mix_pattern, track_idx )
            if alias == -1 then
                local pattern_idx = renoise.song().sequencer:pattern(self.number_of_mix_patterns + 1)
                self:set_next(track_idx, pattern_idx)
            end
        end
    end
end

