--- ======================================================================================================
---
---                                                   Chooser Moudle
---
--- To choose instruments, tracks and track rows.

ChooserData =  {
    access = {
        id    = 1,
        color = 2,
    },
    mode = {
        choose = {1, Color.yellow},
        mute   = {2, Color.red},
    },
    color = {
        clear = Color.off,
    },
}

-- A class to choose the Instruments
class "Chooser" (Module)

require "Module/Chooser/ChooserNoteColumn"
require "Module/Chooser/ChooserPagination"
require "Module/Chooser/ChooserMode"
require "Module/Chooser/ChooserInstrumentRow"




--- ======================================================================================================
---
---                                                 [ INIT ]


function Chooser:__init()
    Module:__init(self)
    self.instrument_idx = 1
    self.track_idx      = 1
    self.row            = 6
    self.mode          = ChooserData.mode.choose
    self.mode_idx      = self.row
    self.color = {
        instrument = {
            active  = Color.flash.green,
            passive = Color.green,
        },
        mute = {
            active  = Color.flash.red,
            passive = Color.red,
        },
        page = {
            active   = Color.yellow,
            inactive = Color.off,
        },
        column = {
            active    = Color.yellow,
            inactive  = Color.dim.green,
            invisible = Color.off,
        },
    }
    -- instruments
    self.inst_offset  = 0  -- which is the first instrument
    -- column
    self.column_idx       = 1 -- index of the column
    self.column_idx_start = 1
    self.column_idx_stop  = 4
    -- callbacks
    self.callback_select_instrument = {}
    self:__create_callbacks()

    self:__init_pagination()
end

function Chooser:wire_launchpad(pad)
    self.pad = pad
end

function Chooser:wire_it_selection(selection)
    self.it_selection = selection
end


function Chooser:__create_callbacks()
    self:__create_column_update()
    self:__create_callback_set_instrument()
    self:__create_instrument_notifier()
    self:__create_mode_listener()
    self:__create_instrument_listener()
    self:__create_instrumnets_notifier_row()
end

--- ======================================================================================================
---
---                                                 [ boot ]

function Chooser:_activate()
    self:__activate_pagination()


    --- chooser line
    self:row_update()
    self.pad:register_matrix_listener(self.instrument_listener)
    add_notifier(renoise.song().instruments_observable, self.instruments_notifier_row)

    --- mode control
    self:mode_update_knobs()
    self.pad:register_right_listener(self.mode_listener)


    --- column logic
    self:column_update_knobs()
    self.pad:register_right_listener(self._column_listener)

end



function Chooser:_deactivate()
    self:__deactivate_pagination()

    self:column_clear_knobs()
    self:mode_clear_knobs()
    self:row_clear()
    self.pad:unregister_matrix_listener(self.instrument_listener)
    self.pad:unregister_right_listener(self._column_listener)
    self.pad:unregister_right_listener(self.mode_listener)
    remove_notifier(renoise.song().instruments_observable, self.instruments_notifier_row)
    remove_notifier(renoise.song().instruments_observable, self.instruments_notifier)
end


function Chooser:__create_callback_set_instrument()
    self.callback_set_instrument = function(instrument_idx, track_idx, column_idx)
        self.instrument_idx = instrument_idx
        self.track_idx      = track_idx
        self.column_idx     = column_idx
        self:row_update()
        self:column_update_knobs()
        self:page_update_knobs()
    end
end




