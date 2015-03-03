--- ======================================================================================================
---
---                                                 [ Pattern Matrix Paginator Module ]
---



function PatternMatrix:__init_paginator()
    self.__pattern_offset = 0
    self.__pattern_offset_factor = 1
    self.__track_offset = 0
    self.__track_offset_factor = 1
end

function PatternMatrix:__activate_paginator()

end

function PatternMatrix:__deactivate_paginator()

end

-- @return hen number
function PatternMatrix:_get_track_idx(x)
    return self.__track_offset + x
end


function PatternMatrix:__inc_track_page()
    -- todo check if possible
    self.__track_offset = self.__track_offset + self.__track_offset_factor
end
function PatternMatrix:__dec_track_page()
    -- todo check if possible
    self.__track_offset = self.__track_offset - self.__track_offset_factor
end
function PatternMatrix:__inc_pattern_page()
    -- todo check if possible
    self.__pattern_offset = self.__pattern_offset + self.__pattern_offset_factor
end
function PatternMatrix:__dec_pattern_page()
    -- todo check if possible
    self.__pattern_offset = self.__pattern_offset - self.__pattern_offset_factor
end
