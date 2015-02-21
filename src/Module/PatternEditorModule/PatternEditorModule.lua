
--- ======================================================================================================
---
---                                                 [ Pattern Editor Module ]
---

--- A module to control Pattern Editor Modules

--- functions need to be implemented for children of this class
--- _render_matrix_position(x,y)

--- it delivers
--- self.__pattern_matrix (+ functions)
--- self.callback_set_pattern
--- self.callback_set_instrument


class "PatternEditorModule" (Module)

require "Module/PatternEditorModule/PatternEditorModuleLaunchpadMatrix"
require "Module/PatternEditorModule/PatternEditorModulePagination"
require "Module/PatternEditorModule/PatternEditorModulePattern"
require "Module/PatternEditorModule/PatternEditorModulePlaybackPosition"
require "Module/PatternEditorModule/PatternEditorModuleTrack"

PatternEditorModuleData = {
    --- used in __pattern_matrix
    note = {
        on    = 1,
        off   = 120,
        empty = 121,
    },
}

function PatternEditorModule:__init(self)
    Module:__init(self)
    --
    self:__init_launchpad_matrix()
    self:__init_pagination()
    self:__init_pattern()
    self:__init_playback_position() -- delivers also __activate and __deactivate
    self:__init_track()
end

