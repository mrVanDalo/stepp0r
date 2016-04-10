--- ======================================================================================================
---
---                                                 [ Main UI ]
---
--- To Create the Dialog, functionallity will be given by wires.


class "MainUI"

function MainUI:__init()
    self.vb = renoise.ViewBuilder()
    self.button_size = 18
    self.text_size   = 70
    self.input_size  = 200
    self.command_button_size = 80
    self.is_running = false
    self.default_osc_port = '8000'
    self:unregister_run_callback()
    self:unregister_quit_callback()
    self:unregister_stop_callback()
end

function MainUI:create_ui()
    self:create_logo()
    self:create_in_device_row()
    self:create_out_device_row()
    self:create_device_info_row()
    self:create_osc_row()
    self:create_rotation_row()
    self:create_follow_mute_row()
    self:create_follow_track_instrument_row()
    self:create_current_playback_position_row()
    self:create_pattern_matrix_row()
    self:create_pagination_factor_row()
    self:create_start_stop_button()
    self:create_quit_button()
    self:create_container()
end

function MainUI:boot()
    self:device_row_update_in_device_list()
    self:device_row_update_out_device_list()
end

function MainUI:create_container()
    self.container = self.vb:column{
        margin = 6,
        spacing = 8,
        self.vb:horizontal_aligner{
            mode = "center",
            self.logo,
        },
        self.vb:column {
            spacing = 4,
            margin = 4,
            self.in_device_row,
            self.out_device_row,
            self.device_info_row,
            self.osc_row,
            self.rotation_row,
            self.pattern_matrix_row,
            self.pagination_factor_row,
            self.follow_mute_row,
            self.follow_track_instrument_row,
            self.current_playback_position_row,
        },
        self.vb:row {
            margin = 4,
            spacing = 4,
            self.start_stop_button,
            self.quit_button,
        }
    }
end

function MainUI:create_logo()
    self.logo = self.vb:bitmap{
        bitmap = "logo.png",
        mode = "transparent",
    }
end


--- ======================================================================================================
---
---                                                 [ Device Row ]

function MainUI:create_in_device_row()
    self.in_device_row_button = self.vb:button{
        visible = true,
        bitmap  = "reload.bmp",
        width   = self.button_size,
        tooltip = "Reload device list",
        notifier = function ()
            self:device_row_update_in_device_list()
        end,
    }
    self.in_device_row_popup = self.vb:popup {
        width = self.input_size,
        tooltip = "Choose the device you want to use. \
(only launchpad devices show up here)",
    }
    self.in_device_row = self.vb:row{
        spacing = 3,
        self.in_device_row_button,
        self.vb:text{
            text = "Input port",
            width = self.text_size,
        },
        self.in_device_row_popup,
    }
end

function MainUI:create_out_device_row()
    self.out_device_row_button = self.vb:button{
        visible = true,
        bitmap  = "reload.bmp",
        width   = self.button_size,
        tooltip = "Reload device list",
        notifier = function ()
            self:device_row_update_out_device_list()
        end,
    }
    self.out_device_row_popup = self.vb:popup {
        width = self.input_size,
        tooltip = "Choose the device you want to use. \
(only launchpad devices show up here)",
    }
    self.out_device_row = self.vb:row{
        spacing = 3,
        self.out_device_row_button,
        self.vb:text{
            text = "Output port",
            width = self.text_size,
        },
        self.out_device_row_popup,
    }
end

function MainUI:disable_device_row()
    self.in_device_row_button.active = false
    self.out_device_row_button.active = false
    self.in_device_row_popup.active = false
    self.out_device_row_popup.active = false
end

function MainUI:enable_device_row()
    self.in_device_row_button.active = true
    self.in_device_row_popup.active = true
    self.out_device_row_button.active = true
    self.out_device_row_popup.active = true
    self:device_row_update_in_device_list()
    self:device_row_update_out_device_list()
end



function MainUI:register_device_update_callback(callback)
    self.device_update_callback = callback
end

function MainUI:device_row_update_in_device_list()
    if (self.device_update_callback) then
        self.in_device_row_popup.items = self.device_update_callback(false)
    end
end

function MainUI:device_row_update_out_device_list()
    if (self.device_update_callback) then
        self.out_device_row_popup.items = self.device_update_callback(true)
    end
end

function MainUI:selected_in_device()
    local list_of_lauchpad_devices = self.in_device_row_popup.items
    return list_of_lauchpad_devices[self.in_device_row_popup.value]
end

function MainUI:selected_out_device()
    local list_of_lauchpad_devices = self.out_device_row_popup.items
    return list_of_lauchpad_devices[self.out_device_row_popup.value]
end

function MainUI:create_device_info_row()
    self.device_info_row = self.vb:row{
        spacing = 3,
        self.vb:text{
            text = "",
            width = self.button_size,
        },
        self.vb:text{
            text =
"You need a Launchpad to start this plugin.\
Plug in a launchpad press the reload button and\
press the start button.\
",
            width = self.text_size + self.input_size,
        },
    }
    self.device_info_row.visible = false
end

function MainUI:disable_device_info_row()
    self.device_info_row.visible = false
end

function MainUI:enable_device_info_row()
    self.device_info_row.visible = true
end



--- ======================================================================================================
---
---                                                 [ Rotation Row ]

function MainUI:create_rotation_row()
    self.rotation_switch = self.vb:switch {
        items = { "left", "right" },
        width = self.input_size,
        tooltip = "Rotate the layout. \
(usefull when you have your pad in a case or you don't have enough space for the usb-cabel)",
    }
    self.rotation_switch.value = 2
    self.rotation_row = self.vb:row{
        spacing = 3,
        self.vb:text{
            text = "",
            width = self.button_size,
        },
        self.vb:text{
            text = "Rotation",
            width = self.text_size,
        },
        self.rotation_switch,
    }
end

function MainUI:disable_rotation_row()
    self.rotation_switch.active = false
end

function MainUI:enable_rotation_row()
    self.rotation_switch.active = true
end

--- ======================================================================================================
---
---                                                 [ Pagination Factor Row ]


function MainUI:create_pagination_factor_row()
    self.pagination_factor_switch = self.vb:switch{
        visible = true,
        items   = {"1", "2", "4"},
        width   = self.input_size,
        tooltip = "Size of a step when pressing pagination buttons",
        value   = 3
    }
    self.pagination_factor_row = self.vb:row{
        spacing = 3,
        self.vb:text{
            text = "",
            width = self.button_size,
        },
        self.vb:text{
            text = "Paging",
            width = self.text_size,
        },
        self.pagination_factor_switch,
    }
end

function MainUI:disable_pagination_factor_row()
    self.pagination_factor_switch.active = false
end


function MainUI:enable_pagination_factor_row()
    self.pagination_factor_switch.active = true
end
--- ======================================================================================================
---
---                                                 [ Pattern Matrix Row ]


function MainUI:create_pattern_matrix_row()
    self.pattern_matrix_switch = self.vb:switch{
        visible = true,
        items   = {"disable", "instantly", "delayed"},
        width   = self.input_size,
        tooltip = "Response on Pattern arrangement. \
* none : will disable the Pattern Mix functionality, \
* instantly : will change the pattern instantly you press the button \
* delayed : will sync the patterns you choose. (good for performing)",
        value   = 3, -- will result in PatternMix.mode
    }
    self.pattern_matrix_row = self.vb:row{
        spacing = 3,
        self.vb:text{
            text = "",
            width = self.button_size
        },
        self.vb:text{
            text = "Pattern Mix",
            width = self.text_size,
        },
        self.pattern_matrix_switch,
    }
end

function MainUI:disable_pattern_matrix_row()
    self.pattern_matrix_switch.active = false
end


function MainUI:enable_pattern_matrix_row()
    self.pattern_matrix_switch.active = true
end


--- ======================================================================================================
---
---                                                 [ Follow Track Instrument Row ]


function MainUI:create_follow_track_instrument_row()
    self.follow_track_instrument_checkbox = self.vb:checkbox{
        visible = true,
        value   = true,
        width   = self.button_size,
        tooltip = "Change instrument focus when changing focus of a track."
    }
    self.follow_track_instrument_row = self.vb:row{
        spacing = 3,
        self.follow_track_instrument_checkbox,
        self.vb:text{
            text = "Follow Track",
            width = self.text_size,
        },
    }
end

function MainUI:disable_follow_track_instrument_row()
    self.follow_track_instrument_checkbox.active = false
end


function MainUI:enable_follow_track_instrument_row()
    self.follow_track_instrument_checkbox.active = true
end
--- ======================================================================================================
---
---                                                 [ Follow Mute Row ]


function MainUI:create_follow_mute_row()
    self.follow_mute_checkbox = self.vb:checkbox{
        visible = true,
        value   = false,
        width   = self.button_size,
        tooltip = "Focus the track when muting it using Stepp0r"
    }
    self.follow_mute_row = self.vb:row{
        spacing = 3,
        self.follow_mute_checkbox,
        self.vb:text{
            text = "Follow Mute",
            width = self.text_size,
        },
    }
end

function MainUI:disable_follow_mute_row()
    self.follow_mute_checkbox.active = false
end


function MainUI:enable_follow_mute_row()
    self.follow_mute_checkbox.active = true
end

--- ======================================================================================================
---
---                                                 [ Only current playback position Row ]


function MainUI:create_current_playback_position_row()
    self.current_playback_position_checkbox = self.vb:checkbox{
        visible = true,
        value   = false,
        width   = self.button_size,
        tooltip = "Don't show the Playposition on the Launchpad if you are focusing a pattern which is not played right now."
    }
    self.current_playback_position_row = self.vb:row{
        spacing = 3,
        self.current_playback_position_checkbox,
        self.vb:text{
            text = "Only current Playbackpositon",
            width = self.text_size,
        },
    }
end

function MainUI:disable_current_playback_position_row()
    self.current_playback_position_checkbox.active = false
end


function MainUI:enable_current_playback_position_row()
    self.current_playback_position_checkbox.active = true
end

--- ======================================================================================================
---
---                                                 [ OSC Row ]

function MainUI:create_osc_row()
    self.osc_row_checkbox = self.vb:checkbox{
        visible = true,
        value   = true,
        width   = self.button_size,
        tooltip = "Use the (internal renoise) OSC server (UDP) to play notes with the keyboard."
    }
    self.osc_row_text = self.vb:text {
        text = 'none',
        width = self.input_size,
        visible = false,
    }
    self.osc_row_textfield = self.vb:textfield {
        text = self.default_osc_port,
        width = self.input_size,
        tooltip = "Port of the osc server (UDP)",
    }
    self.osc_row = self.vb:row{
        spacing = 3,
        self.osc_row_checkbox,
        self.vb:text{
            text = "OSC Port",
            width = self.text_size,
        },
        self.osc_row_textfield,
        self.osc_row_text,
    }
end


function MainUI:disable_osc_row()
    self.osc_row_checkbox.active = false
    self.osc_row_text.text = self.osc_row_textfield.text
    self.osc_row_textfield.visible = false
    self.osc_row_text.visible = true
end


function MainUI:enable_osc_row()
    self.osc_row_checkbox.active = true
    self.osc_row_text.visible = false
    self.osc_row_textfield.visible = true
end







--- ======================================================================================================
---
---                                                 [ Start Stop Buttons ]

function MainUI:create_start_stop_button()
    self.start_stop_button = self.vb:button {
        text = "Start",
        width = self.command_button_size,
        notifier = function ()
            if self.is_running then
                self:stop()
            elseif self:selected_in_device() == "None" or self:selected_out_device() == "None" then
                self:enable_device_info_row()
            else
                self:disable_device_info_row()
                self:run()
            end
        end
    }
end

function MainUI:create_quit_button()
    self.quit_button = self.vb:button {
        text = "Quit",
        width = self.command_button_size,
        notifier = function ()
            self:quit()
        end,
    }
end

--- returns an object of all configurations
function MainUI:run_properties()
    -- pagination factor
    local page_factor = self.pagination_factor_switch.value
    if (page_factor== 3) then
        page_factor = 4
    end
    -- return
    return {
        osc = {
            host   = "localhost"  ,
            port   = tonumber(self.osc_row_textfield.text),
            active = self.osc_row_checkbox.value
        },
        launchpad = {
            in_name = self:selected_in_device(),
            out_name = self:selected_out_device(),
        },
        rotation = self.rotation_switch.value,
        follow_mute = self.follow_mute_checkbox.value,
        follow_track_instrument        = self.follow_track_instrument_checkbox.value,
        only_current_playback_position = self.current_playback_position_checkbox.value,
        pattern_mix_mode = self.pattern_matrix_switch.value - 1,
        pagination_factor = page_factor,
    }
end

function MainUI:register_run_callback(callback)
    self.run_callback = callback
end

function MainUI:unregister_run_callback()
    self.run_callback = function (_) end
end

function MainUI:run()
    self.is_running = true
    self.start_stop_button.text = "Stop"
    self:disable_device_row()
    self:disable_osc_row()
    self:disable_rotation_row()
    self:disable_pagination_factor_row()
    self:disable_follow_mute_row()
    self:disable_follow_track_instrument_row()
    self:disable_current_playback_position_row()
    self:disable_pattern_matrix_row()
    self.run_callback(self:run_properties())
end

function MainUI:register_stop_callback(callback)
    self.stop_callback = callback
end

function MainUI:unregister_stop_callback()
    self.stop_callback = function (_) end
end

function MainUI:stop()
    self.is_running = false
    self.start_stop_button.text = "Start"
    self:enable_device_row()
    self:enable_rotation_row()
    self:enable_follow_mute_row()
    self:enable_follow_track_instrument_row()
    self:enable_current_playback_position_row()
    self:enable_pattern_matrix_row()
    self:enable_pagination_factor_row()
    self:enable_osc_row()
    self.stop_callback()
end

function MainUI:register_quit_callback(callback)
    self.quit_callback = callback
end

function MainUI:unregister_quit_callback()
    self.quit_callback = function (_) end
end

function MainUI:quit()
    self.quit_callback()
--    print("quit")
end
