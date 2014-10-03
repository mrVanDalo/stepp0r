


class "MainUI"

function MainUI:__init()
    self.vb = renoise.ViewBuilder()
    self.button_size = 20
    self.text_size   = 70
    self.input_size  = 200
    self.command_button_size = 80
end

function MainUI:createUI()
    self:create_logo()
    self:create_title()
    self:create_device_row()
    self:create_osc_row()
    self:create_start_stop_button()
    self:create_quit_button()
    self:create_container()
end

function MainUI:create_device_row()
    self.device_row = self.vb:row{
        spacing = 3,
        self.vb:button{
            visible = true,
            text    = "re",
            width   = self.button_size,
        },
        self.vb:text{
            text = "Device",
            width = self.text_size,
        },
        self.vb:popup {
            width = self.input_size,
        },
    }
end

function MainUI:create_osc_row()
    self.osc_row = self.vb:row{
        spacing = 3,
        self.vb:checkbox{
            visible = true,
            value   = true,
            width   = self.button_size,
        },
        self.vb:text{
            text = "OSC Port",
            width = self.text_size,
        },
        self.vb:textfield {
            text = '1234',
            value = '555',
            width = self.input_size,
        }
    }
end

function MainUI:create_container()
    self.container = self.vb:column{
        spacing = 8,
        self.vb:horizontal_aligner{
            mode = "center",
            self.logo,
        },
        self.vb:column {
            spacing = 4,
            margin = 4,
            self.osc_row,
            self.device_row,
        },
        self.vb:row {
            margin = 4,
            spacing = 4,
            self.start_stop_button,
            self.quit_button,
        }
    }
end

function MainUI: create_start_stop_button()
    self.start_stop_button = self.vb:button {
        text = "Start",
        width = self.command_button_size,
    }
end

function MainUI:create_quit_button()
    self.quit_button = self.vb:button {
        text = "Quit",
        width = self.command_button_size,
    }
end


function MainUI:create_logo()
    self.logo = self.vb:bitmap{
        bitmap = "logo.png",
        mode = "transparent",
    }
end

function MainUI:create_title()
    self.title = self.vb:text {
        text = "Awesome"
    }
end

