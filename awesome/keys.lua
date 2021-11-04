local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")

-- {{{
-- Switch tag, while skipping empty ones
-- with teleportation !
local function tag_view_nonempty(step)
    local s = awful.screen.focused()
    local tags = s.tags
    local bound = step > 0 and #tags or 1

    for i = s.selected_tag.index + step, bound, step do
        local t = tags[i]
        if #t:clients() > 0 then
            t:view_only()
            return
        end
    end

    start = step > 0 and 0 or #tags + 1

    for i = start + step, bound, step do
        local t = tags[i]
        if #t:clients() > 0 then
            t:view_only()
            return
        end
    end
end
-- }}}

-- {{{
function update_backlight(cmd, signal)
    awful.spawn.easy_async_with_shell(
        cmd,
        function (stdout)
            local percentage = tonumber(stdout:match('(%d+)'))
            awesome.emit_signal(signal, percentage)
        end
    )
end
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 10, function()
        tag_view_nonempty(1)
    end),
    awful.button({ }, 11, function()
        tag_view_nonempty(-1)
    end),
    awful.button({ }, 9, function()
        tag_view_nonempty(1)
    end),
    awful.button({ }, 8, function()
        tag_view_nonempty(-1)
    end)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "f",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({"Control", "Shift" }, "Tab",
        function()
            tag_view_nonempty(-1)
        end,
              {description = "view previous", group = "tag"}),
    awful.key({         "Control" }, "Tab",
           function()
            tag_view_nonempty(1)
        end,
           {description = "view next", group = "tag"}),

    awful.key({ modkey,           }, "m",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "n",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    -- Layout manipulation
    awful.key({ modkey            }, "d", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey            }, "a", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    -- Standard program
    awful.key({ "Control", "Shift"}, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,    "Shift"}, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey, "Shift" }, "s",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    -- Rofi
    awful.key({"Control"}, "space",
        function () awful.util.spawn("rofi -show run") end,
        {description = "Open rofi", group = "launcher"}
    ),
    -- Volume
    awful.key({ "Shift" }, "XF86AudioRaiseVolume",
        function()
            awful.util.spawn("/home/lenny/dotfiles/scripts/volume -i 1")
        end,
        {description = "Raise volume", group = "volume"}
    ),
    awful.key({ }, "XF86AudioRaiseVolume",
        function()
            awful.util.spawn("/home/lenny/dotfiles/scripts/volume -i 5")
        end,
        {description = "Raise volume", group = "volume"}
    ),
    awful.key({ "Shift" }, "XF86AudioLowerVolume",
        function()
            awful.util.spawn("/home/lenny/dotfiles/scripts/volume -d 1")
        end,
        {description = "Lower volume", group = "volume"}
    ),
    awful.key({ }, "XF86AudioLowerVolume",
        function()
            awful.util.spawn("/home/lenny/dotfiles/scripts/volume -d 5")
        end,
        {description = "Lower volume", group = "volume"}
    ),
    awful.key({ }, "XF86AudioMute",
        function()
            awful.util.spawn("/home/lenny/dotfiles/scripts/volume -t")
        end,
        {description = "Toggle mute", group = "volume"}
    ),
    -- media keys
    awful.key({ }, "XF86AudioPlay",
        function () awful.util.spawn("playerctl play-pause") end,
        {description = "Pause media", group = "media"}
    ),
    awful.key({ }, "XF86AudioNext",
        function () awful.util.spawn("playerctl next") end,
        {description = "Next media", group = "media"}
    ),
    awful.key({ }, "XF86AudioPrev",
        function () awful.util.spawn("playerctl previous") end,
        {description = "Previous media", group = "media"}
    ),
    -- Brightness
    awful.key({ }, "XF86MonBrightnessUp",
        function ()
            update_backlight(
                "/home/lenny/dotfiles/scripts/backlight -l -i 1%",
                "screen_backlight_change"
            )
        end,
        {description = "Increase brightness (1%)", group = "volume"}
    ),
    awful.key({ "Shift"}, "XF86MonBrightnessUp",
        function ()
            update_backlight(
                "/home/lenny/dotfiles/scripts/backlight -l -i 1",
                "screen_backlight_change"
            )
        end,
        {description = "Increase brightness", group = "volume"}
    ),
    awful.key({ }, "XF86MonBrightnessDown",
        function ()
            update_backlight(
                "/home/lenny/dotfiles/scripts/backlight -l -d 1%",
                "screen_backlight_change"
            )
        end,
        {description = "Decrease brightness (1%)", group = "volume"}
    ),
    awful.key({ "Shift"}, "XF86MonBrightnessDown",
        function ()
            update_backlight(
                "/home/lenny/dotfiles/scripts/backlight -l -d 1",
                "screen_backlight_change"
            )
        end,
        {description = "Decrease brightness", group = "volume"}
    ),
    -- Kb backlight
    awful.key({ }, "XF86KbdBrightnessUp",
        function ()
            update_backlight(
                "/home/lenny/dotfiles/scripts/backlight -k -i 1%",
                "keyboard_backlight_change"
            )
        end,
        {description = "Increase keyboard backlight brightness", group = "volume"}
    ),
    awful.key({ }, "XF86KbdBrightnessDown",
        function ()
            update_backlight(
                "/home/lenny/dotfiles/scripts/backlight -k -d 1%",
                "keyboard_backlight_change"
            )
        end,
        {description = "Decrease keyboard backlight brightness", group = "volume"}
    )
)


-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
for i = 1, 10 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ "Mod1" }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey}, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({"Control", "Shift"}, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"})
    )
end

-- Set keys
root.keys(globalkeys)
-- }}}

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end),
    awful.button({ }, 9, function(_)
        tag_view_nonempty(1)
    end),
    awful.button({ }, 8, function(_)
        tag_view_nonempty(-1)
    end),
    awful.button({ }, 10, function(_)
        tag_view_nonempty(1)
    end),
    awful.button({ }, 11, function(_)
        tag_view_nonempty(-1)
    end)
)

clientkeys = gears.table.join(
    awful.key({            "Mod1" }, "Tab",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ "Control"            }, "q",      function (c) c:kill()                      end,
              {description = "close", group = "client"}),
    awful.key({ "Control", "Shift"}, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey            }, "w", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "c",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey            }, "s",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"})
)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
