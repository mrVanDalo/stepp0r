--- ======================================================================================================
---
---                                                 [ Notes ]

--- Renoise Note system
-- should be a standard note translation system,
-- if you need moar information put them at the end of every note,
-- or create a new mappig

--- Definitions
-- Note is a key on the keyboard
-- octave are 13 notes
-- tone is always a combination of note and octave

Note = {
    access = {
        x      = 3,
        y      = 4,
        pitch  = 1,
        label  = 2,
    },
    note = {
        c   = {  0  , "C-"  , 1, 2 },
        cis = {  1  , "C#"  , 2, 1 },
        d   = {  2  , "D-"  , 2, 2 },
        dis = {  3  , "D#"  , 3, 1 },
        e   = {  4  , "E-"  , 3, 2 },
        f   = {  5  , "F-"  , 4, 2 },
        fis = {  6  , "F#"  , 5, 1 },
        g   = {  7  , "G-"  , 5, 2 },
        gis = {  8  , "G#"  , 6, 1 },
        a   = {  9  , "A-"  , 6, 2 },
        ais = { 10  , "A#"  , 7, 1 },
        b   = { 11  , "B-"  , 7, 2 }, -- h
        C   = { 12  , "C-"  , 8, 2 },
        off = { 120 , "OFF" , 4, 1 },
    },
    empty =   { 121 , "---" , 0, 0 },  -- just for completeness
    instrument = { empty = 255 },
    delay      = { empty = 0 },
    volume     = { empty = 255 },
    panning    = { empty = 255 },
}



--- ======================================================================================================
---
---                                                 [ Functions ]

--- calculate pitch
-- ----------------
-- note : Note Object
-- octave : integer of octave
function pitch(note, octave)
    local p = note[Note.access.pitch]
    if (p < 14) then
        return p + (octave * 12)
    else
        return p
    end
end

function is_not_off(note) return note[Note.access.pitch] ~= Note.note.off[Note.access.pitch] end
function is_off(note)     return note[Note.access.pitch] == Note.note.off[Note.access.pitch] end

function print_tone(note,octave)
--    print(("note : %s%s"):format(note[Note.access.label],octave))
end


