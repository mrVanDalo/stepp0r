
class 'InstrumentObject'

function InstrumentObject:__init() end

function InstrumentObject:name_for(instrument)
    if not instrument      then return nil end
    if type(instrument) ~= "Instrument" then return nil end
    if not instrument.name then return nil end
    if instrument.name ~= "" then
        return instrument.name
    end
    if not instrument.midi_output_properties then
        return nil
    end
    if instrument.midi_output_properties.device_name == "" then
        return nil
    else
        return instrument.midi_output_properties.device_name
    end
end
function InstrumentObject:name_for_index(instrument_idx)
    local instrument = renoise.song().instruments[instrument_idx]
    return self:name_for(instrument)
end

function InstrumentObject:exist(instrument)
    if not instrument then
        return false
    end
    local name = self:name_for(instrument)
    if name then
        return true
    else
        return false
    end
end
function InstrumentObject:exist_index(instrument_idx)
    if not instrument_idx then
        return false
    end
    local instrument = renoise.song().instruments[instrument_idx]
    return self:exist(instrument)
end

function InstrumentObject:list()
    return renoise.song().instruments
end

function InstrumentObject:last_idx()
    local result = 0
    for nr,instrument in ipairs( self:list() ) do
        if self:exist(instrument) then
            result = nr
        end
    end
    return result
end

--- a fingerprint to check if something changed
function InstrumentObject:fingerprint()
    -- todo : this must be very fast because it's called a lot of times
    local map = function (instrument)
        if self:exist(instrument) then
            return "1"
        else
            return "0"
        end
    end

    local result = ""
    for _,instrument in ipairs( self:list() ) do
        result = result .. map(instrument)
    end
    return result
end

function InstrumentObject:select_idx(instrument_idx)
    renoise.song().selected_instrument_index = instrument_idx
end


