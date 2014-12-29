
--- ======================================================================================================
---
---                                                 [ Editor Selected Instrument Sub Module ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Chooser:__init_selected_instrument()
    self:__create_set_instrument_callback()
end
function Chooser:__activate_selected_instrument()
end
function Chooser:__deactivate_selected_instrument()
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Editor:__create_set_instrument_callback()
    self.callback_set_instrument = function (instrument_idx, track_idx, column_idx)
        self.track_idx        = track_idx
        self.track_column_idx = column_idx
        self.instrument_idx   = instrument_idx
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end
