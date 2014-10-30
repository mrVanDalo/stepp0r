

--- ======================================================================================================
---
---                                                 [ About UI part ]




class "AboutUI"


function AboutUI:__init()
    self.vb = renoise.ViewBuilder()
    self.topic_size = 100
    self.text_size = 300
    self.design_text = "asdsadf"
    self.author_text = "Ingolf Wagner Aka Palo van Dalo"
end

function AboutUI:create_ui()
    self:create_logo()
    self:create_author_row()
    self:create_design_row()
    self:create_container()
end

function AboutUI:create_logo()
    self.logo = self.vb:bitmap{
        bitmap = "logo.png",
        mode = "transparent",
    }
end

function AboutUI:create_container()
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
            self.author_row,
            self.design_row,
        },
    }
end


function AboutUI:create_author_row()
    self.author_row = self.vb:row{
        spacing = 3,
        self.vb:text{
            text = "Author",
            width = self.topic_size,
        },
        self.vb:text{
            text = self.author_text,
            width = self.text_size,
        },
    }
end

function AboutUI:create_design_row()
    self.design_row = self.vb:row{
        spacing = 3,
        self.vb:text{
            text = "Logo Design",
            width = self.topic_size,
        },
        self.vb:text{
            text = self.design_text,
            width = self.text_size,
        },
    }
end
