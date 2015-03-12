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
    color_map = {
        active_column   = 1,
        inactive_column = 10,
        on    = 1,
        off   = 2,
        empty = 0,
        steppor = 100,
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
    self.playback_key = 'adjuster'
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
        map = self:__get_color_map(),
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

function Adjuster:__get_color_map()
    local active_column   = AdjusterData.color_map.active_column
    local inactive_column = AdjusterData.color_map.inactive_column
    local on    = AdjusterData.color_map.on
    local off   = AdjusterData.color_map.off
    local empty = AdjusterData.color_map.empty
    local steppor = AdjusterData.color_map.steppor
    --
    local active_column_and_on      = NewColor[3][3]
    local active_column_and_off     = NewColor[3][0]
    local active_column_and_empty   = NewColor[0][0]
    local inactive_column_and_on    = NewColor[1][1]
    local inactive_column_and_off   = NewColor[1][0]
    --
    local active_column_and_on_step      = BlinkColor[0][3]
    local active_column_and_off_step     = BlinkColor[0][3]
    local active_column_and_empty_step   = BlinkColor[0][3]
    local inactive_column_and_on_step    = BlinkColor[0][3]
    local inactive_column_and_off_step   = BlinkColor[0][3]
    --
    -- create map
    --
    local map = {}
    map[ active_column * on    + inactive_column * empty ] = active_column_and_on
    map[ active_column * off   + inactive_column * empty ] = active_column_and_off
    map[ active_column * empty + inactive_column * empty ] = active_column_and_empty
    --
    map[ active_column * on    + inactive_column * on    ] = active_column_and_on
    map[ active_column * off   + inactive_column * on    ] = active_column_and_off
    map[ active_column * empty + inactive_column * on    ] = inactive_column_and_on
    --
    map[ active_column * on    + inactive_column * off   ] = active_column_and_on
    map[ active_column * off   + inactive_column * off   ] = active_column_and_off
    map[ active_column * empty + inactive_column * off   ] = inactive_column_and_off
    --
    map[ active_column * on    + inactive_column * empty + steppor ] = active_column_and_on_step
    map[ active_column * off   + inactive_column * empty + steppor ] = active_column_and_off_step
    map[ active_column * empty + inactive_column * empty + steppor ] = active_column_and_empty_step
    --
    map[ active_column * on    + inactive_column * on    + steppor ] = active_column_and_on_step
    map[ active_column * off   + inactive_column * on    + steppor ] = active_column_and_off_step
    map[ active_column * empty + inactive_column * on    + steppor ] = inactive_column_and_on_step
    --
    map[ active_column * on    + inactive_column * off   + steppor ] = active_column_and_on_step
    map[ active_column * off   + inactive_column * off   + steppor ] = active_column_and_off_step
    map[ active_column * empty + inactive_column * off   + steppor ] = inactive_column_and_off_step
    return map
end
