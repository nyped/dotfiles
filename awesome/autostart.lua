local awful = require("awful")

local autostart_app = {
    "blueman-applet"
}

for app = 1, #autostart_app do
    awful.spawn.single_instance(autostart_app[app],
        awful.rules.rules)
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
