--- ======================================================================================================
---
---                                                 [ Note Column Control ]


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]


function Chooser:__init_note_column()
    self.column_idx       = 1 -- index of the column
    self.column_idx_start = 1
    self.column_idx_stop  = 4
    -- create callback
    self:__create_column_update_listener()
end
function Chooser:__activate_note_column()
    self:_update_column_knobs()
    self.pad:register_side_listener(self.__column_listener)
end
function Chooser:__deactivate_note_column()
    self:__clear_column_knobs()
    self.pad:unregister_side_listener(self.__column_listener)
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]


function Chooser:__create_column_update_listener()
    self.__column_listener = function (_,msg)
        if self.is_not_active            then return end
        if msg.vel == Velocity.release   then return end
        if msg.x > self.column_idx_stop  then return end
        if msg.x < self.column_idx_start then return end
        -- self.column_idx = msg.x
        self.it_selection:set_column(msg.x)
--        self.it_selection:ensure_column_idx_exists()
        self:_update_column_knobs()
    end
end

function Chooser:_update_column_knobs()
    -- todo : make this more efficiant
    self.it_selection:sync_track_with_instrument()
    local track = Renoise.sequence_track:track(self.instrument_idx)
    local visible = track.visible_note_columns + self.column_idx_start
    for i = self.column_idx_start, self.column_idx_stop do
        local color = self.color.column.invisible
        if i == self.column_idx then
            color = self.color.column.active
        elseif i < visible then
            color = self.color.column.inactive
        end
        self.pad:set_side(i,color)
    end
end

function Chooser:__clear_column_knobs()
    for i = self.column_idx_start, self.column_idx_stop do
        self.pad:set_side(i,Color.off)
    end
end
