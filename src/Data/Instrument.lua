-- --
-- Instrument Data Container
--
-- stores data about the instruments
-- KeyboardModule for example changes this data
-- Tracker or Stepper read from that Data

require 'Data/InstrumentData'

class "Instruments"

function Instruments:__init()
    self.instruments        = {}
    self._active_instrument = -1
    self._all_notes         = {
        {  0, "C-" },
        {  1, "C#" },
        {  2, "D-" },
        {  3, "D#" },
        {  4, "E-" },
        {  5, "F-" }, 
        {  6, "F#" },
        {  7, "G-" }, 
        {  8, "G#" }, 
        {  9, "A-" },
        { 10, "A#" },
        { 11, "B-" }
    }  
end

function Instruments:set_active_instrument(number)
    if (self.instruments[number]) then
        self._active_instrument = number
    end
end

function Instruments:create_instrument()
    table.insert(self.instruments,InstrumentData(self._all_notes[1]))
end

function Instruments:active_instrument()
    return self.instruments[self._active_instrument]
end

-- forwarding to active instrument
function Instruments:octave_up()   self:active_instrument():octave_up()   end
function Instruments:octave_down() self:active_instrument():octave_down() end
function Instruments:get_octave()  return self:active_instrument().oct    end
