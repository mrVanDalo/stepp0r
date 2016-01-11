
class "CopyPasteStore"

CopyPasteStore.COPY_MODE  = 1
CopyPasteStore.PASTE_MODE = 2

function CopyPasteStore:__init()
    self.store = {
--        SingleEntry(1),
--        SingleEntry(2),
--        SingleEntry(3),
--        SingleEntry(4),
        MultipleEntry(1),
        MultipleEntry(2),
        MultipleEntry(3),
        MultipleEntry(4),
        MultipleEntry(5),
        MultipleEntry(6),
        MultipleEntry(7),
        MultipleEntry(8),
    }
    --
    self.current = self.store[1]
    self.current_observable = renoise.Document.ObservableBang()
    --
    self.mode = CopyPasteStore.COPY_MODE
    self.mode_observable = renoise.Document.ObservableBang()
end

function CopyPasteStore:select(position)
    assert( position < 9, "position to select is to big")
    assert( position > 0, "position to select is to small")
    self.current = self.store[position]
    self.current_observable:bang()
end

function CopyPasteStore:toggle_mode()
   if self.mode == CopyPasteStore.COPY_MODE then
       print("switched mode to paste mode")
       self.mode = CopyPasteStore.PASTE_MODE
   else
       print("switched mode to copy mode")
       self.mode = CopyPasteStore.COPY_MODE
   end
   self.mode_observable:bang()
end



