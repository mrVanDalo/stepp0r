-- Launchpad functions and tests
--

function list_midi_devices () 
    print("output devices")
    for k,v in pairs(renoise.Midi.available_output_devices()) do 
        print(k,v) 
    end
    print("input devices")
    for k,v in pairs(renoise.Midi.available_input_devices()) do 
        print(k,v) 
    end
end
