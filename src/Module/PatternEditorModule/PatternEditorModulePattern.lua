
function PatternEditorModule:__init_pattern()
    self.pattern_idx      = 1 -- actual pattern
    self:__create_callback_set_pattern()
end

function PatternEditorModule:__create_callback_set_pattern()
    self.callback_set_pattern = function (index)
        self.pattern_idx = index
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end

function PatternEditorModule:active_pattern()
    return renoise.song().patterns[self.pattern_idx]
end


