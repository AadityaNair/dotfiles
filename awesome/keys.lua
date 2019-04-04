local rofi_normal = "rofi -show combi"
local rofi_drun = "rofi -show drun"
local screen_locker = "i3lock-fancy -p && sleep 5 && xset dpms force off"

local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")
local naughty = require("naughty")

local keys = {}

-- Mod Keys
local modkey = 'Mod4'
local altkey = 'Mod1'
local ctrlkey = 'Control'
local shiftkey = 'Shift'

-- Mouse Keys
mouse_lmb = 1
mouse_middle = 2
mouse_rmb = 3
mouse_scrollup = 4
mouse_scrolldown = 5
mouse_sidebwd = 8
mouse_sidefwd = 9

-- Mouse bindings
keys.desktopbuttons = gears.table.join(
    awful.button({ }, mouse_rmb, function () mymainmenu:toggle() end),
    awful.button({ }, mouse_scrollup, awful.tag.viewnext),
    awful.button({ }, mouse_scrolldown, awful.tag.viewprev)
)

----------------------  KEY BINDINGS

function toggle_dropdown()
    for _, c in ipairs(client.get()) do
        if c.name == 'tmux' then
            if c.minimized == true then
                c.minimized = false
                c.maximized = true
                c.focus = true
                c.fullscreen = true -- This doesn't work for some reason

                c:tags({awful.screen.focused().selected_tag})
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            else
                c.minimized = true
            end
        end
    end
end

keys.globalkeys = gears.table.join(
---- Workspaces
-- TODO: Focus when there is only a single client
    awful.key({ctrlkey, altkey}, "Up",   awful.tag.viewprev, {description = "view previous", group = "tag"}),
    awful.key({ctrlkey, altkey}, "Down", awful.tag.viewnext, {description = "view next", group = "tag"}),

---- Clients
    awful.key({modkey}, "Right", function () awful.client.focus.byidx( 1) end, {description = "focus next by index", group = "client"}),
    awful.key({modkey}, "Left", function () awful.client.focus.byidx(-1) end, {description = "focus previous by index", group = "client"}),
    awful.key({modkey}, "u", awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}),
    awful.key({modkey}, "Tab",
    function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end, {description = "go back", group = "client"}),

---- Layouts
    awful.key({modkey, shiftkey}, "Right", function() awful.client.swap.byidx(  1) end, {description = "swap with next client by index", group = "client"}),
    awful.key({modkey, shiftkey}, "Left", function() awful.client.swap.byidx( -1) end, {description = "swap with previous client by index", group = "client"}),
    awful.key({modkey, ctrlkey}, "Right", function() awful.tag.incmwfact( 0.05) end, {description = "increase master width factor", group = "layout"}),
    awful.key({modkey, ctrlkey}, "Left", function() awful.tag.incmwfact(-0.05) end, {description = "decrease master width factor", group = "layout"}),
    awful.key({modkey}, "space", function () awful.layout.inc( 1)  end, {description = "select next", group = "layout"}),

---- Applications
    awful.key({modkey}, "Return", function () awful.spawn(terminal) end, {description = "open a terminal", group = "launcher"}),
    awful.key({modkey}, "r", function() awful.spawn(rofi_normal) end, {description = "run prompt", group = "launcher"}),
    awful.key({modkey}, "p", function() awful.spawn(rofi_drun) end, {description = "show the menubar", group = "launcher"}),
    awful.key({}, "F12", toggle_dropdown, {description = "open dropdown", group = "launcher"}),

---- Awesome
    awful.key({modkey}, "s",hotkeys_popup.show_help, {description="show help", group="awesome"}),
    awful.key({modkey}, "l", function() awful.spawn(screen_locker) end, {description = "Lock Screen", group = "awesome"}),
    awful.key({modkey, ctrlkey}, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),
    awful.key({modkey, shiftkey}, "q", awesome.quit, {description = "quit awesome", group = "awesome"})
)
--------------------------------------------

-- TODO: Make this non reliant on tags being numbers. Also, fails with dynamic tags
function move_client_down(c)
    screen = awful.screen.focused()
    local t = client.focus and client.focus.first_tag or nil
    if t == nil or t.name == '5' then
        return
    end

    local tag = screen.tags[t.name+1]
    awful.tag.viewnext()
    c:move_to_tag(tag)
    client.focus = c
    c:raise()
end
function move_client_up(c)
    screen = awful.screen.focused()
    local t = client.focus and client.focus.first_tag or nil
    if t == nil or t.name =='1' then
        return
    end

    local tag = screen.tags[t.name-1]
    awful.tag.viewprev()
    c:move_to_tag(tag)
    client.focus = c
    c:raise()
end
keys.clientkeys = gears.table.join(
    awful.key({modkey}, "f", function (c) c.fullscreen = not c.fullscreen
                                          c:raise() end, {description = "toggle fullscreen", group = "client"}),
    awful.key({modkey, "Shift"}, "c", function(c) c:kill() end, {description = "close", group = "client"}),
    awful.key({modkey, "Control"}, "space", awful.client.floating.toggle, {description = "toggle floating", group = "client"}),
    awful.key({modkey}, "t", function (c) c.ontop = not c.ontop end, {description = "toggle keep on top", group = "client"}),
    awful.key({altkey, ctrlkey, shiftkey}, "Down", move_client_down, {description = 'move client to next screen', group='client'}),
    awful.key({altkey, ctrlkey, shiftkey}, "Up", move_client_up, {description = 'move client to prev screen', group='client'})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 5 do
    keys.globalkeys = gears.table.join(keys.globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

keys.clientbuttons = gears.table.join(
    awful.button({ }, mouse_lmb, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, mouse_lmb, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, mouse_rmb, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

return keys
