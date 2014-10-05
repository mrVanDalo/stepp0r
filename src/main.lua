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


-- Placeholder for the dialog
local dialog = nil
local mainUI = nil
local launchpad_setup = nil



--------------------------------------------------------------------------------
-- Menu entries
--------------------------------------------------------------------------------

renoise.tool():add_menu_entry {
    name = "Main Menu:Tools:"..tool_name.."...",
    invoke = show_dialog
}


--------------------------------------------------------------------------------
-- Main UI
--------------------------------------------------------------------------------


function create_main_UI()
    mainUI = MainUI()
    mainUI:register_run_callback(function (options)
--        print("host")
--        print(options.osc.host)
--        print("port")
--        print(options.osc.port)
--        print("osc active")
--        print(options.osc.active)
--        print("launchpad")
--        print(options.launchpad.name)

        if not options.launchpad.name then
            return
        end

        if options.osc.active then
            launchpad_setup:connect_osc_client(options.osc.host,options.osc.port)
        end

        launchpad_setup:connect_launchpad(options.launchpad.name)
        launchpad_setup:activate()
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

function update_main_UI_callbacks(dialog)
    mainUI:register_quit_callback(function()
        if (dialog) then
            dialog:close()
        end
    end)
end


local function show_dialog()

    -- This block makes sure a non-modal dialog is shown once.
    -- If the dialog is already opened, it will be focused.
    if dialog and dialog.visible then
        dialog:show()
        return
    end

    if not launchpad_setup then
        launchpad_setup = LaunchpadSetup()
        launchpad_setup:wire()
    end

    if not mainUI then
        create_main_UI()
    end

    dialog = renoise.app():show_custom_dialog(tool_name, mainUI.container)
    update_main_UI_callbacks(dialog)

end

