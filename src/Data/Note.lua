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
    access = { -- todo : remove me
        x      = 3, -- todo : remove me
        y      = 4, -- todo : remove me
        pitch  = 1, -- todo : remove me
        label  = 2, -- todo : remove me
    }, -- todo : remove me
    note = {
        c   = {  0  , "C-"  , 1, 2 }, -- todo : remove me
        cis = {  1  , "C#"  , 2, 1 }, -- todo : remove me
        d   = {  2  , "D-"  , 2, 2 }, -- todo : remove me
        dis = {  3  , "D#"  , 3, 1 }, -- todo : remove me
        e   = {  4  , "E-"  , 3, 2 }, -- todo : remove me
        f   = {  5  , "F-"  , 4, 2 }, -- todo : remove me
        fis = {  6  , "F#"  , 5, 1 }, -- todo : remove me
        g   = {  7  , "G-"  , 5, 2 }, -- todo : remove me
        gis = {  8  , "G#"  , 6, 1 }, -- todo : remove me
        a   = {  9  , "A-"  , 6, 2 }, -- todo : remove me
        ais = { 10  , "A#"  , 7, 1 }, -- todo : remove me
        b   = { 11  , "B-"  , 7, 2 }, -- h -- todo : remove me
        C   = { 12  , "C-"  , 8, 2 }, -- todo : remove me
        off = { 120 , "OFF" , 4, 1 }, -- todo : remove me
    },
    empty =   { 121 , "---" , 0, 0 },  -- just for completeness -- todo : remove me
    instrument = { empty = 255 },  -- todo : remove me
    delay      = { empty = 0 }, -- todo : remove me
    volume     = { empty = 255 }, -- todo : remove me
    panning    = { empty = 255 }, -- todo : remove me
}

NewNote = {
    c     = {  pitch = 0   , label = "C-"  , x = 1, y = 2 },
    cis   = {  pitch = 1   , label = "C#"  , x = 2, y = 1 },
    d     = {  pitch = 2   , label = "D-"  , x = 2, y = 2 },
    dis   = {  pitch = 3   , label = "D#"  , x = 3, y = 1 },
    e     = {  pitch = 4   , label = "E-"  , x = 3, y = 2 },
    f     = {  pitch = 5   , label = "F-"  , x = 4, y = 2 },
    fis   = {  pitch = 6   , label = "F#"  , x = 5, y = 1 },
    g     = {  pitch = 7   , label = "G-"  , x = 5, y = 2 },
    gis   = {  pitch = 8   , label = "G#"  , x = 6, y = 1 },
    a     = {  pitch = 9   , label = "A-"  , x = 6, y = 2 },
    ais   = {  pitch = 10  , label = "A#"  , x = 7, y = 1 },
    b     = {  pitch = 11  , label = "B-"  , x = 7, y = 2 }, -- h
    C     = {  pitch = 12  , label = "C-"  , x = 8, y = 2 },
    off   = {  pitch = 120 , label = "OFF" , x = 4, y = 1 },
    empty = {  pitch = 121 , label = "---" , x = 0, y = 0 },  -- just for completeness
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
    print(("note : %s%s"):format(note[Note.access.label],octave))
end


