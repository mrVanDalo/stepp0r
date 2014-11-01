--- ======================================================================================================
---
---                                                 [ Bank of Selection ]


function Adjuster:_insert_bank_at(line)
    local counter = 0
    for position = self.bank_min, self.bank_max do
        self:__insert_bank_line_at_line(line + counter, position)
        counter = counter + 1
    end
end

function Adjuster:__insert_bank_line_at_line(target_line, bank_position)
    -- check for bank entry
    local bank_entry = self.bank[bank_position]
    if not bank_entry then return end
    -- check for position
    local position = self:_get_line(target_line)
    if not position then return end
    -- update position
    position.note_value         = bank_entry[AdjusterData.bank.pitch]
    position.instrument_value   = (self.instrument_idx - 1)
    position.delay_value        = bank_entry[AdjusterData.bank.delay]
    position.panning_value      = bank_entry[AdjusterData.bank.pan]
    position.volume_value       = bank_entry[AdjusterData.bank.vel]
end

function Adjuster:_set_bank_interval(line_start, line_stop, pitch, vel, pan, delay, column)
    for line = line_start, line_stop do
        self:_set_bank(line, pitch, vel, pan, delay,column)
    end
end

function Adjuster:_set_bank(line, pitch,vel, pan, delay, column)
    self.bank[line] = {line, pitch, vel, pan, delay,column }
    if line > self.bank_max then self.bank_max = line end
    if line < self.bank_min then self.bank_min = line end
end

function Adjuster:_clear_bank()
    self.bank = {}
    self.bank_max = 1
    self.bank_min = 1
end

--- updates the matrix (which will be rendered afterwards)
function Adjuster:_update_bank_matrix()
    for line = self.page_start, (self.page_stop - 1), self.zoom do
        local color
        local bank_entry = self.bank[line]
        if not bank_entry then
        elseif bank_entry[AdjusterData.bank.pitch] == Note.empty then
        elseif bank_entry[AdjusterData.bank.pitch] == Note.note.off then
            color = self.color.note.selected.off
        else
            color = self.color.note.selected.on
        end
        local xy = self:line_to_point(line)
        local x = xy[1]
        local y = xy[2]
        self.bank_matrix[x][y] = color
    end
end

