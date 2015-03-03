--- ======================================================================================================
---
---                                                 [ Pattern Matrix Paginator Module ]
---

function PatternMatrix:__init_paginator()
    self.__pattern_offset = 0
    self.__pattern_offset_factor = 1
    self.__track_offset = 0
    self.__track_offset_factor = 1
    self:__create_top_listener()
    self.__pattern_inc_idx = 2
    self.__pattern_dec_idx = 1
    self.__track_inc_idx = 4
    self.__track_dec_idx = 3
    self.color_pagination = {
        pattern = {
            inc = Color.orange,
            dec = Color.orange,
        },
        track = {
            inc = Color.green,
            dec = Color.green,
        },
    }
end

function PatternMatrix:__activate_paginator()
    self.pad:register_top_listener(self.__pagination_top_listener)
    self:__render_pagination()
end

function PatternMatrix:__deactivate_paginator()
    self.pad:unregister_top_listener(self.__pagination_top_listener)
    self:__clear_pagination()
end

function PatternMatrix:__render_pagination()
    self.pad:set_top(self.__pattern_inc_idx, self.color_pagination.pattern.inc)
    self.pad:set_top(self.__pattern_dec_idx, self.color_pagination.pattern.dec)
    self.pad:set_top(self.__track_inc_idx, self.color_pagination.track.inc)
    self.pad:set_top(self.__track_dec_idx, self.color_pagination.track.dec)
end

function PatternMatrix:__clear_pagination()
    self.pad:set_top(self.__pattern_inc_idx, Color.off)
    self.pad:set_top(self.__pattern_dec_idx, Color.off)
    self.pad:set_top(self.__track_inc_idx,Color.off)
    self.pad:set_top(self.__track_dec_idx, Color.off)
end

function PatternMatrix:__create_top_listener()
    self.__pagination_top_listener = function (_, msg)
        if self.is_not_active then return end
        if msg.vel ~= Velocity.release then return end
        local x = msg.x
        if x == self.__pattern_inc_idx then self:__inc_pattern() end
        if x == self.__pattern_dec_idx then self:__dec_pattern() end
        if x == self.__track_inc_idx then self:__inc_track() end
        if x == self.__track_dec_idx then self:__dec_track() end
        self:_refresh_matrix()
    end
end

-- @return track_idx for given x (on matrix)
function PatternMatrix:_get_track_idx(x)
    return self.__track_offset + x
end


function PatternMatrix:__inc_track()
    -- todo check if possible
    self.__track_offset = self.__track_offset + self.__track_offset_factor
end
function PatternMatrix:__dec_track()
    self.__track_offset = self.__track_offset - self.__track_offset_factor
    if self.__track_offset < 0 then
        self.__track_offset = 0
    end
end
function PatternMatrix:__inc_pattern()
    -- todo check if possible
    self.__pattern_offset = self.__pattern_offset + self.__pattern_offset_factor
end
function PatternMatrix:__dec_pattern()
    self.__pattern_offset = self.__pattern_offset - self.__pattern_offset_factor
    if self.__pattern_offset < 0 then
        self.__pattern_offset = 0
    end
end
