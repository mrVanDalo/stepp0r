
class "ColorModule" (Module)


function ColorModule:__init()

end

function ColorModule:wire_launchpad(pad)
    self.pad = pad
end

function ColorModule:_activate()
    for x = 0,3 do
        for y = 0,3 do
            self.pad:set_matrix(x + 1, y + 1, NewColor[x][y])
        end
    end
    for x = 0,3 do
        for y = 0,3 do
            self.pad:set_matrix(x + 5, y + 5, BlinkColor[x][y])
        end
    end
end

function ColorModule:_deactivate()
    for x = 1,8 do
        for y = 1,8 do
            self.pad:set_matrix(x, y, Color.off)
        end
    end
end
