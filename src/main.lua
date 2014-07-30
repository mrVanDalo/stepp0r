--[[============================================================================
main.lua
============================================================================]]--

require 'Init/LaunchpadSetup'
require 'Layer/Launchpad'
require 'Module/Module'
require 'Module/Keyboard'
require 'Module/Chooser'
require 'Module/Stepper'
require 'Module/Effect'
require 'Data/Note'
require 'Data/Color'

-- Placeholder for the dialog
local dialog = nil

-- Placeholder to expose the ViewBuilder outside the show_dialog() function
local vb = nil

-- Reload the script whenever this file is saved. 
-- Additionally, execute the attached function.
_AUTO_RELOAD_DEBUG = function()
  
end

-- Read from the manifest.xml file.
class "RenoiseScriptingTool" (renoise.Document.DocumentNode)
  function RenoiseScriptingTool:__init()    
    renoise.Document.DocumentNode.__init(self) 
    self:add_property("Name", "Untitled Tool")
    self:add_property("Id", "Unknown Id")
  end

local manifest    = RenoiseScriptingTool()
local ok,err      = manifest:load_from("manifest.xml")
local tool_name   = manifest:property("Name").value
local tool_id     = manifest:property("Id").value


--------------------------------------------------------------------------------
-- Main functions
--------------------------------------------------------------------------------

-- This example function is called from the GUI below.
-- It will return a random string. The GUI function displays 
-- that string in a dialog.
local function get_greeting()
  local words = {"Hello world!", "Nice to meet you :)", "Hi there!"}
  local id = math.random(#words)
  return words[id]
end


--------------------------------------------------------------------------------
-- GUI
--------------------------------------------------------------------------------

local launchpad_chooser = nil
local stop_button       = nil
local start_button      = nil

local launchpad_setup   = LaunchpadSetup()
launchpad_setup:wire()

local function get_launchpads()
    local list = {}
    for _,v in pairs(renoise.Midi.available_input_devices()) do
        if string.find(v, "Launchpad") then
            table.insert(list,v)
        end
    end
    return list
end


local function update_launchpad_chooser()
    launchpad_chooser.items = get_launchpads()
end

local function press_refresh()
    update_launchpad_chooser()
end

local function press_start()
    stop_button.visible  = true
    start_button.visible = false
    launchpad_setup:connect(launchpad_chooser.items[launchpad_chooser.value])
    launchpad_setup:activate()
end
local function press_stop()
    stop_button.visible  = false
    start_button.visible = true
    launchpad_setup:deactivate()
end

local function show_dialog()

    -- This block makes sure a non-modal dialog is shown once.
    -- If the dialog is already opened, it will be focused.
    if dialog and dialog.visible then
        dialog:show()
        return
    end

    -- The ViewBuilder is the basis
    vb = renoise.ViewBuilder()

    launchpad_chooser = vb:popup {
        width = 200,
        items = get_launchpads()
    }

    stop_button = vb:button {
        visible = false,
        text    = "stop",
        pressed = press_stop,
    }
    start_button = vb:button {
        visible = true,
        text    = "start",
        pressed = press_start,
    }

    -- The content of the dialog, built with the ViewBuilder.
    local content = vb:column {
        margin = 10,
        spacing = 10,
        vb:text {
            text = "Awesome"
        },
        vb:row {
            vb:text {
                text = "Launchpad : ",
            },
            launchpad_chooser,
        },
        vb:row {
            spacing = 10,
            start_button,
            stop_button,
            vb:button {
                text = "refresh",
                pressed = press_refresh
            },
        },
    }
  
    -- A custom dialog is non-modal and displays a user designed
    -- layout built with the ViewBuilder.
    dialog = renoise.app():show_custom_dialog(tool_name, content)
  
  
    -- A custom prompt is a modal dialog, restricting interaction to itself.
    -- As long as the prompt is displayed, the GUI thread is paused. Since
    -- currently all scripts run in the GUI thread, any processes that were running
    -- in scripts will be paused.
    -- A custom prompt requires buttons. The prompt will return the label of
    -- the button that was pressed or nil if the dialog was closed with the
    -- standard X button.
    --[[
    local buttons = {"OK", "Cancel"}
    local choice = renoise.app():show_custom_prompt(
      tool_name, 
      content, 
      buttons
    )  
    if (choice == buttons[1]) then
      -- user pressed OK, do something  
    end
  --]]


end


--------------------------------------------------------------------------------
-- Menu entries
--------------------------------------------------------------------------------

renoise.tool():add_menu_entry {
    name = "Main Menu:Tools:"..tool_name.."...",
    invoke = show_dialog

}



--------------------------------------------------------------------------------
-- Key Binding
--------------------------------------------------------------------------------

--[[
renoise.tool():add_keybinding {
  name = "Global:Tools:" .. tool_name.."...",
  invoke = show_dialog
}
--]]


--------------------------------------------------------------------------------
-- MIDI Mapping
--------------------------------------------------------------------------------

--[[
renoise.tool():add_midi_mapping {
  name = tool_id..":Show Dialog...",
  invoke = show_dialog
}
--]]
