--- ======================================================================================================
---
---                                                 [ Adjuster Module ]
---
--- Adjustment module (copy/paste after editing)

class "Adjuster" (PatternEditorModule)

require 'Module/Adjuster/AdjusterBank'
require 'Module/Adjuster/AdjusterEffects'
require 'Module/Adjuster/AdjusterLibrary'
require 'Module/Adjuster/AdjusterLaunchpadMatrix'
require 'Module/Adjuster/AdjusterIdle'

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
    PatternEditorModule:__init(self)
    --
    self.delay       = 0
    self.volume      = AdjusterData.instrument.empty
    self.pan         = AdjusterData.instrument.empty
    --
    self.mode        = BankData.mode.copy
    --
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
    --
    self:__init_playback_position()
    self:__init_bank()
    self:__init_launchpad_matrix()
    self:__init_effects()
    self:__init_idle()
end


function Adjuster:_activate()
    self:__activate_playback_position()
    self:__activate_bank()
    self:__activate_effects()
    self:__activate_idle()
    -- must be last
    self:__activate_launchpad_matrix()
end

--- tear down
--
function Adjuster:_deactivate()
    self:__deactivate_bank()
    self:__deactivate_playback_position()
    self:__deactivate_effects()
    self:__deactivate_idle()
    -- must be last
    self:__deactivate_launchpad_matrix()
end


function Adjuster:wire_launchpad(pad)
    self.pad = pad
end
