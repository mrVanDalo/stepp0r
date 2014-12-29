--- ======================================================================================================
---
---                                                 [ Editor Module ]
---
--- stepp the pattern

class "Editor" (Module)

require "Module/Editor/EditorEffects"
require "Module/Editor/EditorLaunchpadMatrix"
require "Module/Editor/EditorLibrary"
require "Module/Editor/EditorPagination"
require "Module/Editor/EditorPlaybackPosition"
require "Module/Editor/EditorSelectedInstrument"
require "Module/Editor/EditorSelectedNote"
require "Module/Editor/EditorSelectedPattern"

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
    }
}

--- ======================================================================================================
---
---                                                 [ INIT ]

function Editor:__init()
    Module:__init(self)
    self.color       = {
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
        },
    }
    -- init submodules
    self:__init_launchpad_matrix()
    self:__init_library()
    self:__init_playback_position()
    self:__init_effects()
    self:__init_pagination()
    self:__init_selected_instrument()
    self:__init_selected_note()
    self:__init_selected_pattern()
end

function Editor:_activate()
    self:__activate_launchpad_matrix()
    self:__activate_library()
    self:__activate_playback_position()
    self:__activate_effects()
    self:__activate_pagination()
    self:__activate_selected_instrument()
    self:__activate_selected_note()
    self:__activate_selected_pattern()
end

function Editor:_deactivate()
    self:__deactivate_library()
    self:__deactivate_playback_position()
    self:__deactivate_effects()
    self:__deactivate_pagination()
    self:__deactivate_selected_instrument()
    self:__deactivate_selected_note()
    self:__deactivate_selected_pattern()
    self:__deactivate_launchpad_matrix()
end


function Editor:wire_launchpad(pad)
    self.pad = pad
end

function Editor:wire_playback_position_observer(playback_position_observer)
    if self.playback_position_observer then
        self:__unregister_playback_position_observer()
    end
    self.playback_position_observer = playback_position_observer
end


