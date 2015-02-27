

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
    self:_render_matrix()
end

function PatternMatrix:_render_matrix()
    for x = 1, 8 do
        for y = 1, 8 do
            local p = self.pattern_matrix[x][y]
            if p then
                local color = self.color.full
                local state = p[PatternMatrixData.matrix.access.state]
                if state == PatternMatrixData.matrix.state.empty then
                   color = self.color.empty
                end
                self.pad:set_matrix(x,y,color)
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


