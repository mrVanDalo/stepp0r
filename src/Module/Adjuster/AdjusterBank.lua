--- ======================================================================================================
---
---                                                 [ Bank of Selection ]
---


function Adjuster:__init_bank()
    self:__create_current_observer()
    self:__create_mode_observer()
end

function Adjuster:__activate_bank()
    self.current_store = self.store.current
    self.mode    = self.store.mode
    add_notifier(self.store.current_observable, self.current_observer)
    add_notifier(self.store.mode_observable, self.mode_observer)
end

function Adjuster:__deactivate_bank()
    remove_notifier(self.store.mode_observable, self.mode_observer)
    remove_notifier(self.store.current_observable, self.current_observer)
end

function Adjuster:wire_store(store)
    self.store = store
end
function Adjuster:__create_current_observer()
    self.current_observer = function()
        self.current_store = self.store.current
        if self.is_active then
            self:_refresh_matrix()
        end
    end
end
function Adjuster:__create_mode_observer()
    self.mode_observer = function()
        self.mode = self.store.mode
    end
end

--- ------------------------------------------------------------------------------------------------------
---
---                                                 [ Lib ]



function Adjuster:_paste(line)
    self.current_store:paste_entry(line, self.instrument_idx, self:active_pattern())
end
function Adjuster:_copy(line_start, line_stop)
    self.current_store:copy(self.pattern_idx, self.track_idx, line_start, line_stop)
end
function Adjuster:_clear(line_start, line_stop)
    self.current_store:clear(line_start, line_stop)
end



