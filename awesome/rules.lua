local awful = require("awful")
local ruled = require("ruled")

-- {{{ Rules
ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id         = "titlebars",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = false      }
    }

    ruled.client.append_rule {
        rule = { instance = "[Ff]irefox" },
        properties = {
            tag = "1",
            maximized = false,
            floating = false,
            switch_to_tags = true
        }
    }
    ruled.client.append_rule {
        rule = { class = "terminal" },
        properties = { tag = "3", floating = false }
    }
    ruled.client.append_rule {
        rule = { class = "Zathura" },
        properties = { tag = "4" }
    }
    ruled.client.append_rule {
        rule = { class = "discord" },
        properties = { tag = "5" }
    }
    ruled.client.append_rule {
        rule = { class = "qBittorrent" },
        properties = { tag = "10" }
    }
    ruled.client.append_rule {
        rule = { class = "[Ss]potify" },
        properties = { tag = "9" }
    }
    ruled.client.append_rule {
        rule = { class = "Terminal" },
        properties = {
            floating = true,
            width    = 524,
            height   = 297,
            placement  = awful.placement.bottom_right
        }
    }
    ruled.client.append_rule {
        rule_any = {
            class = { "Spyder", "java-lang-Thread" }
        },
        properties = { tag = "2" }
    }
    ruled.client.append_rule {
        rule_any = {
            class = { "vlc", "Vlc" }
        },
        properties = { tag = "7" }
    }
end)
-- }}}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
