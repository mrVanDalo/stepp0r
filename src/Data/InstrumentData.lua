-- --
-- represents an Instrument configuration
class "InstrumentData"

function InstrumentData:__init(note)
    self.index = -1 -- index number of instrument
    self.note  = note
    self.oct   = 4
end

function InstrumentData:tostring()
    return self:note_letter()
end

function InstrumentData:note_number()
    return self.note[1] + (12 * self.oct)
end

function InstrumentData:note_letter()
    return ("%s%s"):format(self.note[2],self.oct)
end

function InstrumentData:octave_down()
    if (self.oct > 1) then
        self.oct = self.oct - 1
    end
end
function InstrumentData:octave_up()
    if (self.oct < 8) then
        self.oct = self.oct + 1
    end
end
