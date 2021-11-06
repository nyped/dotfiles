-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local awful = require("awful")
require("awful.autofocus")
require("awful.hotkeys_popup.keys")

-- Theme handling library
local beautiful = require("beautiful")
beautiful.init("~/.config/awesome/theme.lua")

-- Global definition
require("global")

-- Notification stuff
require("notifications")

-- Signals
require("signals")

-- System info popup
require("popup")

-- Setting the cursor
awful.util.spawn("xsetroot -cursor_name left_ptr")

-- Pretty bar
require("bar")

-- Keybinds
require("keys")

-- Rules
require("rules")

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
