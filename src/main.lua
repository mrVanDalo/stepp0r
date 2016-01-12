require 'Init/LaunchpadSetup'
require 'UI/MainUI'
require 'UI/AboutUI'


-- Reload the script whenever this file is saved.
-- Additionally, execute the attached function.
_AUTO_RELOAD_DEBUG = function()  end

-- Read from the manifest.xml file.
class "RenoiseScriptingTool" (renoise.Document.DocumentNode)
  function RenoiseScriptingTool:__init()    
    renoise.Document.DocumentNode.__init(self) 
    self:add_property("Name", "Untitled Tool")
    self:add_property("Id", "Unknown Id")
    self:add_property("Version", "Unknown Version")
  end

local manifest     = RenoiseScriptingTool()
local ok,err       = manifest:load_from("manifest.xml")
local tool_name    = manifest:property("Name").value
local tool_id      = manifest:property("Id").value
local tool_version = manifest:property("Version").value


-- Placeholder for the dialog
local main_dialog = nil
local main_ui = nil

local about_dialog = nil
local about_ui = nil

local launchpad_setup = nil







--- ======================================================================================================
---
---                                                 [ Main Dialog ]


function create_main_UI()
    main_ui = MainUI()
    main_ui:register_run_callback(function (options)

        if not options.launchpad.name then
            return
        end

        if options.launchpad.name == "None" then
            return
        end

        if options.osc.active then
            launchpad_setup:connect_osc_client(options.osc.host,options.osc.port)
        end

        if options.follow_mute then
            launchpad_setup:set_follow_mute()
        else
            launchpad_setup:unset_follow_mute()
        end

        launchpad_setup:set_pattern_mix_mode(options.pattern_mix_mode)
        launchpad_setup:set_pagination_factor(options.pagination_factor)
        launchpad_setup:set_only_current_playback_position(options.only_current_playback_position)
        if options.follow_track_instrument then
            launchpad_setup:set_follow_track_instrument()
        else
            launchpad_setup:unset_follow_track_instrument()
        end

        launchpad_setup:connect_launchpad(options.launchpad.name, options.rotation)
        launchpad_setup:connect_it_selection()
        launchpad_setup:activate()
    end)
    main_ui:register_stop_callback(function ()
--        print("stop")
        launchpad_setup:deactivate()
    end)
    main_ui:register_device_update_callback(function ()
        local list = {}
        for _,v in pairs(renoise.Midi.available_input_devices()) do
            if string.find(v, "Launchpad") then
                table.insert(list,v)
            end
        end
        return list
    end)
    main_ui:create_ui()
    main_ui:boot()
end

function update_main_UI_callbacks(main_dialog)
    main_ui:register_quit_callback(function()
        if (main_dialog) then
            main_dialog:close()
        end
    end)
end


local function show_about()
    if not about_ui then
        about_ui = AboutUI()
        about_ui:create_ui()
    end
    renoise.app():show_custom_dialog("About ".. tool_name  .. " " .. tool_version, about_ui.container)
end

local function show_main_dialog()

    -- This block makes sure a non-modal dialog is shown once.
    -- If the dialog is already opened, it will be focused.
    if main_dialog and main_dialog.visible then
        main_dialog:show()
        return
    end

    if not launchpad_setup then
        launchpad_setup = LaunchpadSetup()
        launchpad_setup:wire()
    end

    if not main_ui then
        create_main_UI()
    end

    main_dialog = renoise.app():show_custom_dialog(tool_name .. " " .. tool_version, main_ui.container)
    update_main_UI_callbacks(main_dialog)

end

renoise.tool().app_new_document_observable:add_notifier(function()
    if launchpad_setup then
        launchpad_setup:deactivate()
        launchpad_setup = LaunchpadSetup()
        launchpad_setup:wire()
    end
    print("new renoise track")
end)


--- ======================================================================================================
---
---                                                 [ Menu Entry ]


renoise.tool():add_menu_entry {
    name = "Main Menu:Tools:"..tool_name,
    invoke = show_main_dialog
}
renoise.tool():add_menu_entry {
    name = "Main Menu:Help:".. "About "..tool_name,
    invoke = show_about
}
