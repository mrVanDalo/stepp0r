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

--bank = {
--    line   = 1,
--    pitch  = 2,
--    vel    = 3,
--    pan    = 4,
--    delay  = 5,
--    column = 6,
--},

function Adjuster:__init_bank()
    self.bank_matrix = {}
    self:_clear_bank()
    self:__create_bank_update_handler()
end

function Adjuster:__activate_bank()
    self:_clear_bank_matrix()
    self:_update_bank_matrix()
end

function Adjuster:__deactivate_bank()
    self:_clear_bank_matrix()
end


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]

function Adjuster:__create_bank_update_handler()
    self.bank_update_handler = function (bank, mode)
        self.bank     = bank
        self.mode     = mode
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end


--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Bank Functions ]

function Adjuster:_insert_bank_at_line(line)
    local counter = 0
    local start_to_insert = false
    for position = self.bank.min, self.bank.max do
        -- check for bank entry
        local bank_entry = self.bank.bank[position]
        if bank_entry then start_to_insert = true end
        if start_to_insert then
            self:__insert_bank_line_at_line(line + counter, bank_entry)
            counter = counter + 1
        end
    end
end
function Adjuster:__insert_bank_line_at_line(target_line, bank_entry)
    if not bank_entry then return end
    -- check for position
    local position = self:_get_line(target_line)
    if not position then return end
    -- update position
    local note_value = bank_entry.pitch
    if note_value == Note.empty[Note.access.pitch] then
        position.note_value       = note_value
        position.instrument_value = Note.instrument.empty
        position.delay_value      = Note.delay.empty
        position.panning_value    = Note.panning.empty
        position.volume_value     = Note.volume.empty
    else
        position.note_value       = note_value
        position.instrument_value = (self.instrument_idx - 1)
        position.delay_value      = bank_entry.delay
        position.panning_value    = bank_entry.pan
        position.volume_value     = bank_entry.vel
    end
end



function Adjuster:_update_bank_interval(line_start, line_stop)
    local pattern_iter  = renoise.song().pattern_iterator
    for pos,line in pattern_iter:lines_in_pattern_track(self.pattern_idx, self.track_idx) do
        if pos.line >= line_start and pos.line <= line_stop then
            self:__update_bank_position(pos.line,line)
        end
    end
end
function Adjuster:__update_bank_position(pos, line)
    if table.is_empty(line.note_columns) then return end
    local note_column = line:note_column(self.track_column_idx)
    self.bank.bank[pos] = {
        pos         = pos,
        note_column = note_column,
        pitch       = note_column.note_value,
        vel         = note_column.volume_value,
        pan         = note_column.panning_value,
        delay       = note_column.delay_value,
        column      = self.track_column_idx,
    }
    -- save bank bank_information
    if pos > self.bank.max then self.bank.max = pos end
    if pos < self.bank.min then self.bank.min = pos end
end

function Adjuster:_clear_bank()
    self.bank = create_bank()
end

-- todo update this algorithm
function Adjuster:_clear_bank_interval(line_start, line_stop)
    for line = line_start, line_stop do
        self.bank.bank[line] = nil
    end
    --  we don't clear the borders, because it is to muche work, with will not amorise.
end



--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Bank Matrix ]

--- updates the matrix (which will be rendered afterwards)
function Adjuster:_update_bank_matrix()
    for line = self.page_start, (self.page_end - 1) do
        local color
        local bank_entry = self.bank.bank[line]
        if not bank_entry then
        elseif bank_entry.pitch == Note.empty then
            color = self.color.selected.empty
        elseif bank_entry.pitch == Note.note.off then
            color = self.color.selected.off
        else
            color = self.color.selected.on
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
    local bank_entry = self.bank.bank[line]
    if not bank_entry then
    elseif bank_entry.pitch == Note.empty then
        color = self.color.selected.empty
    elseif bank_entry.pitch == Note.note.off then
        color = self.color.selected.off
    else
        color = self.color.selected.on
    end
    self.bank_matrix[x][y] = color
end

function Adjuster:_clear_bank_matrix()
    self.bank_matrix = {}
    for x = 1, 8 do self.bank_matrix[x] = {} end
end

