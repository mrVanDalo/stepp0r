--- ======================================================================================================
---
---                                                 [ Editor Module ]
---
--- stepp the pattern

class "Editor" (PatternEditorModule)

require "Module/Editor/EditorEffects"
require "Module/Editor/EditorLaunchpadMatrix"
require "Module/Editor/EditorSelectedNote"
require "Module/Editor/EditorIdle"

EditorData = {
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
    }
}

--- ======================================================================================================
---
---                                                 [ INIT ]

function Editor:__init()
    PatternEditorModule:__init(self)
    --
    self.playback_key = 'editor'
    --
    self.color       = {
        stepper = Color.green,
        map = self:__get_color_map(),
    }
    -- init submodules
    self:__init_launchpad_matrix()
    self:__init_playback_position()
    self:__init_effects()
    self:__init_selected_note()
    self:__init_idle()
end

function Editor:_activate()
    self:__activate_launchpad_matrix()
    self:__activate_playback_position()
    self:__activate_effects()
    self:__activate_selected_note()
    self:__activate_idle()
end

function Editor:_deactivate()
    self:__deactivate_playback_position()
    self:__deactivate_effects()
    self:__deactivate_selected_note()
    self:__deactivate_launchpad_matrix()
    self:__deactivate_idle()
end


function Editor:wire_launchpad(pad)
    self.pad = pad
end


function Editor:__get_color_map()
    local active_column   = EditorData.color_map.active_column
    local inactive_column = EditorData.color_map.inactive_column
    local on    = EditorData.color_map.on
    local off   = EditorData.color_map.off
    local empty = EditorData.color_map.empty
    local steppor = EditorData.color_map.steppor
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
