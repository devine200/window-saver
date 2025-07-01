require("hs.ipc")

storeDB = function (windows_info)
    local jsonString = hs.json.encode(windows_info)
    local file = io.open(hs.configdir .. "/db.json", "w")
    if not file then error("Failed to open file for writing") end

    file:write(jsonString)
    file:close()
    local success, result = pcall(function()
    end)

    if not success then
        hs.alert("storeDB error: " .. result)
        print("storeDB error:", result)
    end
end

retrieveDB = function()
    local file = io.open(hs.configdir .. "/db.json", "r")
    if not file then
        hs.alert("No database found")
        return {}
    end

    local content = file:read("*a")
    file:close()

    local windows_info = hs.json.decode(content)
    if not windows_info then
        hs.alert("Failed to decode JSON")
        return {}
    end

    return windows_info

end

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()

    f.w = f.w - 10
    hs.alert.show("CMD+ALT+CTRL+W pressed")
    win:setFrame(f)
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "E", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()

    for i, v in pairs(f) do
        print(i, v)
    end
    f.w = f.w + 10
    hs.alert.show("CMD+ALT+CTRL+E pressed")
    win:setFrame(f)
end)


hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "Left", function()
    -- Get the focused screen via the currently focused window
    local focusedWindow = hs.window.focusedWindow()
    local focusedScreen = focusedWindow and focusedWindow:screen()

    if not focusedScreen then
        print("No focused screen found.")
        return
    end

    -- Get all visible windows and filter by screen
    local allWindows = hs.window.visibleWindows()
    local windowsOnFocusedScreen = {}

    for _, win in ipairs(allWindows) do
        if win:screen() == focusedScreen then
            table.insert(windowsOnFocusedScreen, win)
        end
    end

    -- Print the titles of the windows on the focused screen
    local window_info = {}
    for _, win in ipairs(windowsOnFocusedScreen) do
        local frame = win:frame()
        local window_data = {
            app_name = win:application():name(),
            app_bundle_id = win:application():bundleID(),
            screen_name = win:screen():name(),
            frame = {
                x = frame.x,
                y = frame.y,
                w = frame.w,
                h = frame.h
            }
        }
        table.insert(window_info, window_data)
    end
    hs.alert.show("Windows info length: " .. #window_info)
    storeDB(window_info)
    hs.alert.show("window information has been added to store")
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "Right", function()
    local stored_windows = retrieveDB()

    for i, v in ipairs(stored_windows) do
        hs.alert.show("Opening App: " .. v.app_name .. "on " .. v.screen_name .. " Screen")

        local app = hs.application.open(v.app_bundle_id)
        local app_window = app:mainWindow()

        if app_window then
            local frame = app_window:frame()
            frame.x = v.frame.x
            frame.y = v.frame.y
            frame.w = v.frame.w
            frame.h = v.frame.h
            app_window:setFrame(frame)
        else
            hs.alert.show("No main window for " .. v.app_name)
        end
    end
end)
