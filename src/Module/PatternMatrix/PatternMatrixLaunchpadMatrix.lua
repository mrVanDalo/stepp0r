

function PatternMatrix:__init_launchpad()
    self:__create_matrix_listener()
end

function PatternMatrix:__activate_launchpad()
    self:_refresh_matrix()
    self.pad:register_matrix_listener(self.__matrix_listener)
end

function PatternMatrix:__deactivate_launchpad()
    self:_clear_launchpad()
    self.pad:unregister_matrix_listener(self.__matrix_listener)
end

function PatternMatrix:wire_launchpad(pad)
    self.pad = pad
end

function PatternMatrix:__create_matrix_listener()
    self.__matrix_listener = function (_, msg)
--        print("press ", msg.x, ", ", msg.y)
        if self.is_not_active then return end
        if msg.vel ~= Velocity.release then return end
        if self.mode == PatternMatrixData.mode.mix then
            self:__set_mix_to_next_pattern(msg.x,msg.y)
        elseif self.mode == PatternMatrixData.mode.copy then
            self:__copy_pattern(msg.x,msg.y)
        else
            self:__clear_pattern(msg.x, msg.y)
        end
    end
end

function PatternMatrix:_ensure_sequence_idx_exist(sequence_idx)
    Renoise.pattern_matrix:create_patterns_up_to_sequence_index(sequence_idx)
end


function PatternMatrix:__clear_pattern(x,y)
    local track_idx   = self:_get_track_idx(x)
    local pattern_idx = self:_get_pattern_idx(y)
    renoise.song().patterns[pattern_idx].tracks[track_idx]:clear()
    self:_refresh_matrix()
end
function PatternMatrix:__copy_pattern(x,y)
    local track_idx   = self:_get_track_idx(x)
    local pattern_idx = self:_get_pattern_idx(y)
    local alias_idx   = self:_get_pattern_alias_idx(self.active_mix_pattern, track_idx)
    if alias_idx ~= -1 then
        local source_pattern_track = renoise.song().patterns[alias_idx].tracks[track_idx]
        renoise.song().patterns[pattern_idx].tracks[track_idx]:copy_from(source_pattern_track)
        self:_set_mix_to_pattern(track_idx, pattern_idx)
        self:_refresh_matrix()
    end
end
function PatternMatrix:__set_mix_to_next_pattern(x,y)
    local track_idx   = self:_get_track_idx(x)
    local pattern_idx = self:_get_pattern_idx(y)
    local alias_idx   = self:_get_pattern_alias_idx(self.next_mix_pattern,track_idx)
--    print("track_idx ", track_idx, " pattern_idx ", pattern_idx, " alias_idx ", alias_idx)
    if alias_idx ~= -1 and pattern_idx == alias_idx then
        -- use it_selection
        Renoise.track:select_idx(track_idx)
--        renoise.song().selected_track_index = track_idx
    else
        self:_set_mix_to_pattern(track_idx, pattern_idx)
    end
    self:_render_matrix()
end

function PatternMatrix:_refresh_matrix()
    self:_clear_matrix()
    self:_update_matrix()
    self:_render_matrix()
end

function PatternMatrix:_render_matrix()
    self:_clear_launchpad()
    for x = 1, 8 do
        --
        local x_track = self:_get_track_idx(x)
        local track_activation = PatternMatrixData.matrix.state.inactive
        if x_track == self.__track_idx then
            track_activation = PatternMatrixData.matrix.state.active
        end
        --
        local active_pattern_idx = self:_get_pattern_alias_idx(self.active_mix_pattern, x_track)
        local next_pattern_idx   = self:_get_pattern_alias_idx(self.next_mix_pattern,   x_track)
        --
        local group = PatternMatrixData.matrix.state.group_a
        if self:_get_group_idx(x) == 0 then
            group = PatternMatrixData.matrix.state.group_b
        end
        --
        for y = 1, 8 do
            local p = self.pattern_matrix[x][y]
            if p then
                local state       = p[PatternMatrixData.matrix.access.state]
                local pattern_idx = p[PatternMatrixData.matrix.access.pattern_idx]
                if active_pattern_idx == pattern_idx then
                    self.pad:set_matrix(x,y, self.color[PatternMatrixData.matrix.state.set    + group + state + track_activation])
                elseif next_pattern_idx == pattern_idx then
                    self.pad:set_matrix(x,y, self.color[PatternMatrixData.matrix.state.next   + group + state + track_activation])
                else
                    self.pad:set_matrix(x,y, self.color[PatternMatrixData.matrix.state.no_mix + group + state + track_activation])
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


