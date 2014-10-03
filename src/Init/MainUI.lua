


class "MainUI"

function MainUI:__init()
    self.vb = renoise.ViewBuilder()
    self.button_size = 40
    self.text_size   = 100
    self.input_size  = 150
end

function MainUI:createUI()
    self:create_logo()
    self:create_title()
    self:create_device_row()
    self:create_osc_row()
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
        self.logo,
        self.vb:column {
            spacing = 4,
            margin = 4,
            self.osc_row,
            self.device_row,
        }
    }
end

function MainUI:create_logo()
    self.logo = self.vb:bitmap{
        bitmap = "logo.png"
    }
end

function MainUI:create_title()
    self.title = self.vb:text {
        text = "Awesome"
    }
end

