

--- ======================================================================================================
---
---                                                 [ About UI part ]




class "AboutUI"


function AboutUI:__init()
    self.vb = renoise.ViewBuilder()
    self.topic_size = 40
    self.text_width = 350
    self.text_height = 250
    self.textarea_text = {
        "Author",
        "====",
        "Ingolf Wagner Aka Palo Van Dalo","",
        "Logo",
        "===",
        "© by stylefusion.de","",
        "Homepage",
        "=======",
        "http://mrvandalo.github.io/stepp0r/","",
        "License",
        "=====",
        "GPLv3 http://www.gnu.org/copyleft/gpl.html",
    }
end

function AboutUI:create_ui()
    self:create_logo()
    self:create_textarea()
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
        margin = 8,
        spacing = 13,
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
        self.textarea
    }
end

function AboutUI:create_textarea()
    self.textarea = self.vb:multiline_text{
        paragraphs = self.textarea_text,
        width = self.text_width,
        height = self.text_height,
    }
end

