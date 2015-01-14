--- ======================================================================================================
---
---                                                 [ Adjuster Module ]
---
--- Adjustment module (copy/paste after editing)

class "Adjuster" (Module)

require 'Module/Adjuster/AdjusterBank'
require 'Module/Adjuster/AdjusterPlaybackPosition'
require 'Module/Adjuster/AdjusterSelectedPattern'
require 'Module/Adjuster/AdjusterPagination'
require 'Module/Adjuster/AdjusterCallbacks'
require 'Module/Adjuster/AdjusterLibrary'
require 'Module/Adjuster/AdjusterLaunchpadMatrix'
require 'Module/Adjuster/AdjusterPattern'

AdjusterData = {
    note = {
        off   = 120,
        empty = 121,
    },
    instrument = { empty = 255 },
    delay      = { empty = 0 },
    volume     = { empty = 255 },
    panning    = { empty = 255 },
    color = {
        clear = Color.off
    },
    bank = {
        line   = 1,
        pitch  = 2,
        vel    = 3,
        pan    = 4,
        delay  = 5,
        column = 6,
    },
}

--- ======================================================================================================
---
---                                                 [ INIT ]

function Adjuster:__init()
    Module:__init(self)

    -- position
    self.track_idx        = 1
    self.instrument_idx   = 1
    self.track_column_idx = 1 -- the column in the track
    self.pattern_idx      = 1 -- actual pattern

    self.note        = Note.note.c
    self.octave      = 4

    self.delay       = 0
    self.volume      = AdjusterData.instrument.empty
    self.pan         = AdjusterData.instrument.empty

    self.mode        = BankData.mode.copy

    -- ---
    -- navigation
    -- ---

    -- zoom
    self.zoom         = 1 -- influences grid size

    -- rendering
    self.color = {
        stepper = Color.green,
        page = {
            active   = Color.yellow,
            inactive = Color.off,
        },
        zoom = {
            active   = Color.yellow,
            inactive = Color.off,
        },
        note = {
            off   = Color.red,
            on    = Color.yellow,
            empty = Color.off,
            selected = {
                off   = Color.flash.green,
                on    = Color.flash.green,
                empty = Color.flash.green,
            }
        },
    }

    self:__init_playback_position()
    self:__init_bank()
    self:__init_selected_pattern()
    self:__init_pagination()
    self:__init_launchpad_matrix()
    self:__init_callbacks()
    self:__init_pattern()
end


function Adjuster:_activate()
    self:__activate_playback_position()
    self:__activate_bank()
    self:__activate_selected_pattern()
    self:__activate_pagination()
    self:__activate_callbacks()
    self:__activate_pattern()
    -- must be last
    self:__activate_launchpad_matrix()
end

--- tear down
--
function Adjuster:_deactivate()
    self:__deactivate_bank()
    self:__deactivate_playback_position()
    self:__deactivate_selected_pattern()
    self:__deactivate_pagination()
    self:__deactivate_callbacks()
    self:__deactivate_pattern()
    -- must be last
    self:__deactivate_launchpad_matrix()
end


function Adjuster:wire_launchpad(pad)
    self.pad = pad
end
