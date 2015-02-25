--- ======================================================================================================
---
---                                                 [ Pattern Matrix Paginator Module ]
---



function PatternMatrix:__init_paginator()
    self.__pattern_page = 1
    self.__track_page   = 1
    self:__create_it_selection_listerner()
end

function PatternMatrix:__activate_paginator()

end

function PatternMatrix:__deactivate_paginator()

end



