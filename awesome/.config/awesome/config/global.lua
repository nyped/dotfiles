local awful = require("awful")
local menubar = require("menubar")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")

-- {{{ Variable definitions
modkey = "Mod4"
terminal = "kitty"
editor = "nvim"
editor_cmd = terminal .. " -e " .. editor
script_path = "/home/lenny/bin/"
-- }}}

-- {{{ Global states
theme_name = "night"
player_title = ""
player_info = "Not playing"
player_cover = beautiful.icon_path .. "player/cover.png"
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    {
        "hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end,
    },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    {
        "quit",
        function()
            awesome.quit()
        end,
    },
}

mymainmenu = awful.menu({
    items = {
        {
            "awesome",
            myawesomemenu,
            beautiful.awesome_icon,
        },
        {
            "open terminal",
            terminal,
        },
    },
})

-- Menubar configuration
menubar.utils.terminal = terminal
-- }}}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
