
--- ======================================================================================================
---
---                                                 [ Editor Selected Instrument Sub Module ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Editor:__init_selected_instrument()
    self.track_idx       = 1
    self.instrument_idx  = 1
    self.track_column_idx = 1 -- the column in the track
    self:__create_set_instrument_callback()
end
function Editor:__activate_selected_instrument()
end
function Editor:__deactivate_selected_instrument()
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
