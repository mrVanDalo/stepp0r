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


function PatternMatrix:__create_it_selection_listerner()
    self.callback_set_instrument = function (instrument_idx, track_idx, column_idx)
        self.__track_idx = track_idx
        if self.is_not_active then return end
        self:_refresh_matrix()
    end
end
