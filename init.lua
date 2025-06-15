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

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
  end
)


hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
    -- local visible_windows = hs.window.visibleWindows()

    -- for i, win in ipairs(visible_windows) do
    --     hs.alert("name: " .. win:application():name() .. ", title: " .. win:title() .. ", screen:" .. win:screen():name())
    -- end

    local win = hs.window.focusedWindow()
    local other = win:otherWindowsSameScreen()
    local screen = hs.screen.mainScreen()

    for i, owin in pairs(other) do
        if owin:isVisible() then
            -- owin:minimize()
            hs.alert("name: " .. owin:application():name() .. ", size: " .. owin:frame().x .. "x" .. owin:frame().y)
            -- hs.alert("name: " .. owin:application():name() .. ", title: " .. owin:title() .. ", screen:" .. owin:screen():name())
        else
            hs.alert(" Window is not standard")
        end
    end
  end)