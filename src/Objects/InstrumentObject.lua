
class 'InstrumentObject'

function InstrumentObject:__init() end

function InstrumentObject:name_for(instrument)
    if not instrument      then return nil end
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
--    print("name : ", name)
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

