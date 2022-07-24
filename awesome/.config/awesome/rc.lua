-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local awful = require("awful")
require("awful.autofocus")
require("awful.hotkeys_popup.keys")

require("theme")
require("config")
require("ui")

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
