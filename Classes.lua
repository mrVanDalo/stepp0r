-- Example on how classes are created
--
-- [found in Renoise.Document.API.lua]
--
class "Launchpad"

function Launchpad:__init(text)
    self.text = text
end

function Launchpad:foo()
    print(self.text)
end
