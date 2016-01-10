
class "CopyPasteStore"

CopyPasteStore.modes = {
    copy  = 1,
    paste = 2,
}

function CopyPasteStore:__init()
    self.store = {
        SingelEntry(1),
        SingelEntry(2),
        SingelEntry(3),
        SingelEntry(4),
        MultipleEntry(5),
        MultipleEntry(6),
        MultipleEntry(7),
        MultipleEntry(8),
    }
    --
    self.current = self.store[1]
    self.current_observable = renoise.Document.ObservableBang()
    --
    self.mode = CopyPasteStore.modes.copy
    self.mode_observable = renoise.Document.ObservableBang()
end

function CopyPasteStore:select(position)
    assert( position < 9, "position to select is to big")
    assert( position > 0, "position to select is to small")
    self.current = self.store[position]
    self.current_observable:bang()
end

function CopyPasteStore:toggle_mode()
   if self.mode == CopyPasteStore.modes.copy then
       self.mode = CopyPasteStore.modes.paste
   else
       self.mode = CopyPasteStore.modes.copy
   end
   self.mode_observable:bang()
end



