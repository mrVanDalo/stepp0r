--- ======================================================================================================
---
---                                                 [ Pattern Matrix Paginator Module ]
---



function PatternMatrix:__init_paginator()
    self.__pattern_page = 1
    self.__track_page   = 1
end

function PatternMatrix:__activate_paginator()

end

function PatternMatrix:__deactivate_paginator()

end

function PatternMatrix:_get_track_idx(x)
    return (( self.__track_page - 1 ) * 8 + x)
--    return x
end

function PatternMatrix:__inc_track_page()
    -- todo check if possible
    self.__track_page = self.__track_page + 1
end
function PatternMatrix:__dec_track_page()
    -- todo check if possible
    self.__track_page = self.__track_page - 1
end
function PatternMatrix:__inc_pattern_page()
    -- todo check if possible
    self.__pattern_page = self.__pattern_page + 1
end
function PatternMatrix:__dec_pattern_page()
    -- todo check if possible
    self.__pattern_page = self.__pattern_page - 1
end
