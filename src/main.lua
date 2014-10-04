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
require 'Init/MainUI'

-- Placeholder for the dialog
local dialog = nil
local ui = nil
local vb = nil
local mainUI = nil

-- Reload the script whenever this file is saved.
-- Additionally, execute the attached function.
_AUTO_RELOAD_DEBUG = function()  end

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


local launchpad_setup   = LaunchpadSetup()
launchpad_setup:wire()


local function show_dialog()

    -- This block makes sure a non-modal dialog is shown once.
    -- If the dialog is already opened, it will be focused.
    if dialog and dialog.visible then
        dialog:show()
        return
    end

    if not mainUI then
        create_main_UI()
    end
    dialog = renoise.app():show_custom_dialog(tool_name, mainUI.container)
    update_main_UI_callbacks()

  
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

function create_main_UI()
    mainUI = MainUI()
    mainUI:register_run_callback(function (options)
        print("host")
        print(options.osc.host)
        print("port")
        print(options.osc.port)
        print("osc active")
        print(options.osc.active)
        print("launchpad")
        print(options.launchpad.name)

        if options.launchpad.name then
            launchpad_setup:connect(options.launchpad.name)
            launchpad_setup:activate()
        end
    end)
    mainUI:register_stop_callback(function ()
        print("stop")
        launchpad_setup:deactivate()
    end)
    mainUI:register_device_update_callback(function ()
        local list = {}
        for _,v in pairs(renoise.Midi.available_input_devices()) do
            if string.find(v, "Launchpad") then
                table.insert(list,v)
            end
        end
        return list
    end)
    mainUI:create_ui()
    mainUI:boot()
end

function update_main_UI_callbacks()
    mainUI:register_quit_callback(function()
        if (dialog) then
            dialog:close()
        end
    end)
end



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
