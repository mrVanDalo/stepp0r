
function Bank:_render_matrix()
    local y1 = 1 + self.offset
    local y2 = 2 + self.offset
    for x = 1, 8 do
        if x == self.bank_idx then
            if self.mode == BankData.mode.copy then
                self.pad:set_matrix(x, y1, self.color.toggle.selected.copy)
            else
                self.pad:set_matrix(x, y1, self.color.toggle.selected.paste)
            end
        else
            self.pad:set_matrix(x, y1, self.color.toggle.unselected)
        end
        self.pad:set_matrix(x, y2, self.color.clear)
    end
end

function Bank:_clear_matrix()
    local y1 = 1 + self.offset
    local y2 = 2 + self.offset
    for x = 1, 8 do
        self.pad:set_matrix(x,y1, Color.off)
        self.pad:set_matrix(x,y2, Color.off)
    end
end