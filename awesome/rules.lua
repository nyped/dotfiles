local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      },
      properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }

    -- Custom rules
    },
    { rule = { instance = "Firefox" },
      properties = { tag = "1" }
    },
    { rule = { class = "kitty" },
      properties = { tag = "3" }
    },
    { rule = { class = "Zathura" },
      properties = { tag = "4" }
    },
    { rule = { class = "discord" },
      properties = { tag = "5" }
    },
    { rule = { class = "qBittorrent" },
      properties = { tag = "10" }
    },
    { rule = { class = "Spotify" },
      properties = { tag = "9" }
    },
    { rule_any = {
        class = { "Spyder", "java-lang-Thread" }
      },
      properties = { tag = "2" }
    },
    { rule_any = {
        class = { "vlc", "Vlc" }
      },
      properties = { tag = "7" }
    },
}

-- }}}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
