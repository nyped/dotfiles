local awful = require("awful")
local ruled = require("ruled")

local function no_class_handle(c)
    local cmd = "ps -p " .. tostring(c.pid) .. " -o comm= 2>/dev/null"
    -- Getting the caller name
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        local screen = client.focus.screen
        local owner = stdout:gsub("[\r\n]", "")
        local target
        c.class = owner
        if owner == "spotify" then
            target = awful.tag.find_by_name(screen, "music")
            c:move_to_tag(target)
        end
    end)
end

-- {{{ Rules
ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rule({
        id = "global",
        rule = {},
        callback = function(c)
            -- new windows placement
            c:to_secondary_section()
            -- Check for missing class
            if c.class == nil or c.class == "" then
                no_class_handle(c)
            end
        end,
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap
                + awful.placement.no_offscreen
                + awful.placement.centered,
            maximized_horizontal = false,
            maximized_vertical = false,
            maximized = false,
            floating = false,
        },
    })

    -- Floating clients.
    ruled.client.append_rule({
        id = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "Sxiv",
                "Tor Browser",
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
            },
            name = { "Event Tester" }, -- xev
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
            },
            type = { "utility" },
        },
        properties = { floating = true },
    })

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule({
        id = "titlebars",
        rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true },
    })

    -- Floating dialog
    ruled.client.append_rule({
        rule_any = { type = { "dialog" } },
        properties = {
            floating = true,
            placement = awful.placement.centered,
        },
    })

    ruled.client.append_rule({
        rule = { class = "firefox" },
        properties = { tag = "web" },
    })
    ruled.client.append_rule({
        rule = { class = "terminal" },
        properties = { tag = "console" },
    })
    ruled.client.append_rule({
        rule = { class = "Zathura" },
        properties = { tag = "doc" },
    })
    ruled.client.append_rule({
        rule = { class = "libreoffice*" },
        properties = { tag = "office" },
    })
    ruled.client.append_rule({
        rule = { class = "discord" },
        properties = { tag = "chat" },
    })
    ruled.client.append_rule({
        rule = { class = "qBittorrent" },
        properties = { tag = "download" },
    })
    ruled.client.append_rule({
        rule = { class = "matplotlib" },
        properties = { floating = true },
    })
    ruled.client.append_rule({
        rule = { class = "Terminal" },
        properties = {
            floating = true,
            width = 524,
            height = 297,
            placement = awful.placement.bottom_right,
        },
    })
    ruled.client.append_rule({
        rule_any = { class = { "Spyder", "java-lang-Thread" } },
        properties = { tag = "search" },
    })
    ruled.client.append_rule({
        rule_any = { class = { "Vlc", "vlc" } },
        properties = { tag = "video" },
    })
    ruled.client.append_rule({
        rule = { class = "burp*" },
        properties = { tag = "search" },
    })
    ruled.client.append_rule({
        rule_any = { class = { "pavucontrol", "Pavucontrol" } },
        properties = { tag = "music" },
    })
end)
-- }}}

-- {{{ Padding for each tag
awful.tag.attached_connect_signal(nil, "property::selected", function(t)
    local s = t.screen or awful.screen.focused()
    local padding = t.padding or { left = 0, right = 0, top = 0, bottom = 0 }
    s.padding = padding
end)
-- }}}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
