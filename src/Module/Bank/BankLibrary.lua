
function Bank:_toggle_mode(bank_idx)
    self.bank_idx = bank_idx
    if self.mode == BankData.mode.copy then
        self.mode = BankData.mode.paste
    else
        self.mode = BankData.mode.copy
    end
    self:_update_bank_listeners()
    self:_render_matrix()
end

function Bank:_clear_bank(bank_idx)
    self.bank_idx = bank_idx
    self.mode = BankData.mode.copy
    self:_update_bank_listeners()
    self:_render_matrix()
end


