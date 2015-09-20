--- ======================================================================================================
---
---                                                 [ Pattern Mix Module ]
---
---
--- keeps track on the mix patterns (and updates the other one)
--- Mix patterns are the (one or two or zero patterns on top of the pattern list) which are used to mix
--- stuff together
--

class "PatternMix"

require 'Layer/PatternMix/PatternMixCurrentAndNext'
require 'Layer/PatternMix/PatternMixArea'

PatternMixData = {
    row = {
        mix_1 = "__stepp0r_mix_1",
        mix_2 = "__stepp0r_mix_2"
    },
    mode = {
        delayed   = 2,
        instantly = 1,
    },
    first_sequence_idx = 3, -- the first sequence after the mix area

}

function PatternMix:__init()
    self:__init_area()
    self:__init_current_and_next()
    --
    self.__update_callbacks         = {}
    --
    self:__create_selected_pattern_idx_listener()
    self:__create_callback_set_instrument()
end

function PatternMix:connect()
    self:__activate_area()
    self:__activate_current_and_next()
    add_notifier(renoise.song().selected_pattern_index_observable, self.__selected_pattern_idx_listener)
    self:_update_callbacks()
end

function PatternMix:disconnect()
    self:__deactivate_current_and_next()
    self:__deactivate_area()
    remove_notifier(renoise.song().selected_pattern_index_observable, self.__selected_pattern_idx_listener)
end


function PatternMix:__create_selected_pattern_idx_listener()
    self.__selected_pattern_idx_listener = function ()
        self:_update_current_and_next()
        if self.is_not_active then return end
        self:_adjuster_next_pattern()
        self:_update_callbacks()
    end
end






function PatternMix:__create_callback_set_instrument()
    self.callback_set_instrument =  function (instrument_idx, track_idx, column_idx)
        -- if the current mix pattern is empty fill it with the default value
        if not Renoise.pattern_matrix:alias_idx(self.current_mix_pattern, track_idx) then
            self:_adjuster_next_pattern()
        end
    end
end



function PatternMix:register_update_callback(callback)
    table.insert(self.__update_callbacks, callback)
end
function PatternMix:_update_callbacks()
    local sequence_idx_blacklist = {}
    if self.area.first.idx then
        table.insert(sequence_idx_blacklist, self.area.first.idx)
    end
    if self.area.second.idx then
        table.insert(sequence_idx_blacklist, self.area.second.idx)
    end
    local update = {
        current                = self.current_mix_pattern,
        next                   = self.next_mix_pattern,
        sequence_idx_blacklist = sequence_idx_blacklist
    }
    for _, callback in ipairs(self.__update_callbacks) do
        callback(update)
    end
end

