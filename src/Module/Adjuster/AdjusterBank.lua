

function Adjuster:_update_bank_inteval(line_start, line_stop, pitch, vel, pan, delay, column)
    for line = line_start, line_stop do
        self:_update_bank(line, pitch, vel, pan, delay,column)
    end
end

function Adjuster:_update_bank(line, pitch,vel, pan, delay, column)
    self.bank[line] = {line, pitch, vel, pan, delay,column}
end

function Adjuster:_clear_bank()
    self.bank = {}
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
