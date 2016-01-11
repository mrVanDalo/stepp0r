--- ======================================================================================================
---
---                                                 [ Bank of Selection ]

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Sub-Module Interface ]
---
--- the bank min max borders will only be updated for inserting. but not for deleting, because the work will not
--- amorise while pasting. (multiple times stepping an array to optimze maybe one or two steps through the array
--- is not efficient.

--- bank[pos] = { pos, pitch, vel, pan, delay, column} -- single line mode
--- bank[pos] = {{ pos, pitch, vel, pan, delay, column}, { pos, pitch, ... } , { ... } } -- multiple line mode


function Adjuster:__init_bank()
    self.bank_matrix = {}
    self:__create_current_observer()
end

function Adjuster:__activate_bank()
    self.current = self.store.current
    self.mode    = self.store.mode
    self:_clear_bank_matrix()
    self:_update_bank_matrix()
    add_notifier(self.store.current_observable, self.current_observer)
    add_notifier(self.store.mode_observable, self.mode_observer)
end


function Adjuster:__deactivate_bank()
    remove_notifier(self.store.mode_observable, self.mode_observer)
    remove_notifier(self.store.current_observable, self.current_observer)
    self:_clear_bank_matrix()
end

function Adjuster:wire_store(store)
    self.store = store
end


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Adjuster:__create_current_observer()
    self.current_observer = function()
        self.current = self.store.current
        if self.is_active then
            self:_refresh_matrix()
        end
    end
    self.mode_observer = function()
        self.mode = self.store.mode
    end
end


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Bank Functions ]

function Adjuster:_insert_bank_at_line(line)
    -- todo : inline?
    self.current:paste_entry(line, self.instrument_idx, self:active_pattern())
end

function Adjuster:_update_bank_interval(line_start, line_stop)
    -- todo : inline?
    self.current:copy(self.pattern_idx, self.track_idx, line_start, line_stop)
end

function Adjuster:_clear_bank()
    -- inline?
    self.current:reset()
end

function Adjuster:_clear_bank_interval(line_start, line_stop)
    -- inline?
    self.current:clear(line_start, line_stop)
end



--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Bank Matrix ]

--- updates the matrix (which will be rendered afterwards)
function Adjuster:_update_bank_matrix()
    for line = self.page_start, (self.page_end - 1) do
        local color
        local bank_entry = self.current:selection(line)
        if bank_entry == Entry.SELECTED then
            color = self.color.selected.on
        else
            color = nil
        end
        local xy = self:line_to_point(line)
        if xy then
            local x = xy[1]
            local y = xy[2]
            self.bank_matrix[x][y] = color
        end
    end
end
function Adjuster:_update_bank_matrix_position(x,y)
    local line = self:point_to_line(x,y)
    if not line then return end
    local color
    local bank_entry = self.current:selection(line)
    if bank_entry == Entry.SELECTED then
        color = self.color.selected.on
    else
        color = nil
    end
    self.bank_matrix[x][y] = color
end

function Adjuster:_clear_bank_matrix()
    self.bank_matrix = {}
    for x = 1, 8 do self.bank_matrix[x] = {} end
end

