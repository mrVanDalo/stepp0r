

--- to save one column

class "SingleEntry" (Entry)

function SingleEntry:__init(position)
    Entry:__init(self)
    self.position = position
    self.bank     = {}
    self.min      = 1
    self.max      = 1
end



function SingleEntry:paste_entry(line, instrument_idx, active_pattern, note_column_idx)

    local write = function(column, entry)
        if entry.pitch == NewNote.empty.pitch then
            entry = Entry.note.empty
            column.instrument_value = Entry.instrument.empty
        else
            column.instrument_value = (instrument_idx - 1)
        end
        column.note_value       = entry.pitch
        column.delay_value      = entry.delay
        column.panning_value    = entry.pan
        column.volume_value     = entry.vol
    end

    local update_line = function (target_line, bank_entry)
        if not bank_entry then return end
        --
        local position = self:get_line(target_line, active_pattern, Renoise.sequence_track:track_idx(instrument_idx))
        if not position then return end
        --
        local column = position.note_columns[note_column_idx]
        if not column then return end
        --
        local entry = bank_entry
        if not entry then return end
        --
        write(column, entry)
    end

    -- position where to start
    local start_position = function()
        for position = self.min, self.max do
            local bank_entry = self.bank[position]
            if bank_entry then return position end
        end
        return self.max
    end

    -- iterate over everything
    local counter = 0
    for position = start_position(), self.max do
        -- check for bank entry
        local bank_entry = self.bank[position]
        update_line(line + counter, bank_entry)
        counter = counter + 1
    end

end

function SingleEntry:copy(pattern_idx, track_idx, line_start, line_stop, note_column_idx)

    local update_bank = function (line_number, line)
        local note_column = line.note_columns[note_column_idx]
        local bank_entry = {
            pos         = line_number,
            note_column = note_column,
            pitch       = note_column.note_value,
            vol         = note_column.volume_value,
            pan         = note_column.panning_value,
            delay       = note_column.delay_value,
            column      = note_column_idx,
        }
        self.bank[line_number] = bank_entry
        -- save bank bank_information
        if line_number > self.max then self.max = line_number end
        if line_number < self.min then self.min = line_number end
    end

--    print("--- [ copy:")
--    print("pattern " .. pattern_idx)
--    print("track   " .. track_idx)
--    print("[" .. line_start .. " , " .. line_stop .. "]")
    -- todo: why iterative over everything?
    local pattern_iter  = renoise.song().pattern_iterator
    for pos,line in pattern_iter:lines_in_pattern_track(pattern_idx, track_idx) do
        if pos.line >= line_start and pos.line <= line_stop then
            update_bank(pos.line,line)
        end
    end
end

function SingleEntry:clear(line_start, line_stop)
    for line = line_start, line_stop do
        self.bank[line] = nil
    end
end

function SingleEntry:reset()
    self.bank = {}
    self.min  = 1
    self.max  = 1
end

function SingleEntry:selection( position, note_column_idx )
    if self.bank[position] then
        if self.bank[position].column == note_column_idx  then
            return Entry.SELECTED
        end
    end
    return Entry.UNSELECTED
end
