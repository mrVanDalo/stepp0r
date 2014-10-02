


class "MainUI"

function MainUI:__init()
    self.vb = renoise.ViewBuilder()
end

function MainUI:createUI()
    self:createLogo()
    self:createTitle()
    self:createContainer()
end

function MainUI:createContainer()
    self.container = self.vb:column{
        margin = 10,
        spacing = 10,
        self.title,
        self.logo,
    }
end

function MainUI:createLogo()
    self.logo = self.vb:bitmap{
        bitmap = "logo.png"
    }
end

function MainUI:createTitle()
    self.title = self.vb:text {
        text = "Awesome"
    }
end

