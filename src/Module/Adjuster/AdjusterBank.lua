--- ======================================================================================================
---
---                                                 [ Bank of Selection ]

function Adjuster:_create_bank_callbacks()
    self:__create_bank_update_handler()
end

function Adjuster:_insert_bank_at(line)
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
    local note_value = bank_entry[AdjusterData.bank.pitch]
--    print("note value " .. target_line .. " : " .. note_value)
    if note_value == Note.empty[Note.access.pitch] then
        position.note_value       = note_value
        position.instrument_value = Note.instrument.empty
        position.delay_value      = Note.delay.empty
        position.panning_value    = Note.panning.empty
        position.volume_value     = Note.volume.empty
    else
        position.note_value       = note_value
        position.instrument_value = (self.instrument_idx - 1)
        position.delay_value      = bank_entry[AdjusterData.bank.delay]
        position.panning_value    = bank_entry[AdjusterData.bank.pan]
        position.volume_value     = bank_entry[AdjusterData.bank.vel]
    end
end

-- todo rename it
function Adjuster:_set_bank_interval(line_start, line_stop)
    local pattern_iter  = renoise.song().pattern_iterator
    for pos,line in pattern_iter:lines_in_pattern_track(self.pattern_idx, self.track_idx) do
        if pos.line >= line_start and pos.line <= line_stop then
            self:__update_bank_matrix_position(pos.line,line)
        end
    end
end

function Adjuster:__update_bank_matrix_position(pos, line)
    if table.is_empty(line.note_columns) then return end
    local note_column = line:note_column(self.track_column_idx)
    local pitch = note_column.note_value
    local vel = note_column.volume_value
    local panning = note_column.panning_value
    local delay = note_column.delay_value
    self:__set_bank(pos, pitch, vel , panning, delay, self.track_column_idx)
end

function Adjuster:__set_bank(line, pitch,vel, pan, delay, column)
    self.bank.bank[line] = {line, pitch, vel, pan, delay,column }
    if line > self.bank.max then self.bank.max = line end
    if line < self.bank.min then self.bank.min = line end
end

function Adjuster:_clear_bank_interval(line_start, line_stop)
    for line = line_start, line_stop do
        self.bank.bank[line] = nil
    end
    if self.bank.max <= line_stop and self.bank.max >= line_start then
        self.bank.max = line_start
    end
    if self.bank.min <= line_stop and self.bank.min >= line_start then
        self.bank.min = line_stop
    end
end

function Adjuster:_clear_bank()
    self.bank = create_bank()
end

--- updates the matrix (which will be rendered afterwards)
function Adjuster:_update_bank_matrix()
    for line = self.page_start, (self.page_end - 1) do
        local color
        local bank_entry = self.bank.bank[line]
        if not bank_entry then
        elseif bank_entry[AdjusterData.bank.pitch] == Note.empty then
            color = self.color.note.selected.empty
        elseif bank_entry[AdjusterData.bank.pitch] == Note.note.off then
            color = self.color.note.selected.off
        else
            color = self.color.note.selected.on
        end
        local xy = self:line_to_point(line)
        if xy then
            local x = xy[1]
            local y = xy[2]
            self.bank_matrix[x][y] = color
        end
    end
end

function Adjuster:_update_bank_matrix_at_point(x,y)
    local line = self:point_to_line(x,y)
    if not line then return end

    local color
    local bank_entry = self.bank.bank[line]
    if not bank_entry then
    elseif bank_entry[AdjusterData.bank.pitch] == Note.empty then
        color = self.color.note.selected.empty
    elseif bank_entry[AdjusterData.bank.pitch] == Note.note.off then
        color = self.color.note.selected.off
    else
        color = self.color.note.selected.on
    end
    self.bank_matrix[x][y] = color
end

function Adjuster:_clear_bank_matrix()
    self.bank_matrix = {}
    for x = 1, 8 do self.bank_matrix[x] = {} end
end


function Adjuster:_log_bank()
--    print("log bank")
--    for position = self.bank.min, self.bank.max do
--        local bank_entry = self.bank.bank[position]
--        if (bank_entry) then
--            print(position .. " : " .. bank_entry[AdjusterData.bank.pitch])
--        else
--            print(position .. ' : nil')
--        end
--    end
end
