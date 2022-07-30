local awful = require("awful")

local autostart_app = {
    "blueman-applet",
    "nm-applet",
}

for app = 1, #autostart_app do
    awful.spawn.single_instance(autostart_app[app], awful.rules.rules)
end

-- Setting the cursor
awful.util.spawn("xsetroot -cursor_name left_ptr")

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
