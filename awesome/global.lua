local awful   = require("awful")
local wibox   = require("wibox")
local menubar = require("menubar")
local beautiful     = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")

-- {{{ Variable definitions
modkey     = "Mod4"
terminal   = "kitty"
editor     = "nvim"
editor_cmd = terminal .. " -e " .. editor
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({
    items = {
        {
            "awesome",
            myawesomemenu,
            beautiful.awesome_icon
        },
        {
            "open terminal",
            terminal
        }
    }
})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal
-- }}}
