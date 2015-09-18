--- ======================================================================================================
---
---                                                 [ Pattern Matrix Paginator Module ]
---

function PatternMatrix:__init_paginator()
    self.__pattern_offset = 0
    self.__pattern_offset_factor = 1
    self.__track_offset = 0

    self.__pattern_inc_idx = 2
    self.__pattern_dec_idx = 1

    self.color_pagination = {
        pattern = {
            active   = NewColor[2][3],
            inactive = NewColor[0][1],
        },
    }
    self:__create_top_listener()
    self:__create_track_paginator_update_callback()
end

function PatternMatrix:__activate_paginator()
    self.pad:register_top_listener(self.__pagination_top_listener)
    self:__render_pagination()
end

function PatternMatrix:__deactivate_paginator()
    self.pad:unregister_top_listener(self.__pagination_top_listener)
    self:__clear_pagination()
end

function PatternMatrix:set_pattern_offset_factor(factor)
    self.__pattern_offset_factor = factor
end

function PatternMatrix:__create_track_paginator_update_callback()
    self.track_paginator_update_callback = function (page)
        self.__track_offset = page.page_offset
        if self.is_not_active then return end
        self:_refresh_matrix()
    end
end


function PatternMatrix:__render_pagination()
    self.pad:set_top(self.__pattern_inc_idx, self.color_pagination.pattern.active)
    if self.__pattern_offset == 0 then
        self.pad:set_top(self.__pattern_dec_idx, self.color_pagination.pattern.inactive)
    else
        self.pad:set_top(self.__pattern_dec_idx, self.color_pagination.pattern.active)
    end
end

function PatternMatrix:__clear_pagination()
    self.pad:set_top(self.__pattern_inc_idx, Color.off)
    self.pad:set_top(self.__pattern_dec_idx, Color.off)
end

function PatternMatrix:__create_top_listener()
    self.__pagination_top_listener = function (_, msg)
        if self.is_not_active then return end
        if msg.vel ~= Velocity.release then return end
        local x = msg.x
        if x == self.__pattern_inc_idx then self:__inc_pattern() end
        if x == self.__pattern_dec_idx then self:__dec_pattern() end
        self:_refresh_matrix()
    end
end

-- @return track_idx for given x (on matrix)
function PatternMatrix:_get_track_idx(x)
    local position = self.__track_offset + x
--    local tracks_without_group = Renoise.track:sequencer_track_sequence()
--    return tracks_without_group[position]
    return Renoise.track:track_idx_for_sequence_idx(position)
end
function PatternMatrix:_get_group_idx(x)
    local position = self.__track_offset + x
    return Renoise.sequence_track:group_type_2(position)
end

function PatternMatrix:__inc_pattern()
    -- todo check if possible
    self.__pattern_offset = self.__pattern_offset + self.__pattern_offset_factor
    self:__render_pagination()
end
function PatternMatrix:__dec_pattern()
    self.__pattern_offset = self.__pattern_offset - self.__pattern_offset_factor
    if self.__pattern_offset < 0 then
        self.__pattern_offset = 0
    end
    self:__render_pagination()
end
