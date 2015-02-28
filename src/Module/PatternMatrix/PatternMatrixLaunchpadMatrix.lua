

function PatternMatrix:__init_launchpad()

end

function PatternMatrix:__activate_launchpad()
    self:_refresh_matrix()
end

function PatternMatrix:__deactivate_launchpad()
    self:_clear_launchpad()
end

function PatternMatrix:wire_launchpad(pad)
    self.pad = pad
end

function PatternMatrix:_refresh_matrix()
    self:_clear_matrix()
    self:_update_matrix()
    self:_clear_launchpad()
    self:_render_matrix()
end

function PatternMatrix:_render_matrix()
    for x = 1, 8 do
        --
        local track_activation = PatternMatrixData.matrix.state.inactive
        if x == self.__track_idx then
            track_activation = PatternMatrixData.matrix.state.active
        end
        --
        local active_pattern_idx = self:_get_pattern_alias_idx(self.active_mix_pattern)
        local next_pattern_idx   = self:_get_pattern_alias_idx(self.next_mix_pattern)
        --
        for y = 1, 8 do
            local p = self.pattern_matrix[x][y]
            if p then
                local pattern_idx = p[PatternMatrixData.matrix.access.pattern_idx]
                if active_pattern_idx == pattern_idx then
                    self.pad:set_matrix(x,y, self.color[PatternMatrixData.matrix.state.set  + track_activation])
                elseif next_pattern_idx == pattern_idx then
                    self.pad:set_matrix(x,y, self.color[PatternMatrixData.matrix.state.next + track_activation])
                else
                    local state       = p[PatternMatrixData.matrix.access.state]
                    self.pad:set_matrix(x,y, self.color[state + track_activation])
                end
            end
        end
    end
end

function PatternMatrix:_clear_launchpad()
    for x = 1, 8 do
        for y = 1, 8 do
            self.pad:set_matrix(x,y,Color.off)
        end
    end
end


