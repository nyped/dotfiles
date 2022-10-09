local beautiful = require("beautiful")
local wibox = require("wibox")

local systray = wibox.widget({
    wibox.widget.systray(),
    draw_empty = false,
    top = beautiful.icon_v_padding,
    bottom = beautiful.icon_v_padding,
    layout = wibox.container.margin,
})

-- Themed colors
awesome.connect_signal("theme_change", function(theme)
    beautiful.bg_systray = beautiful.theme[theme].bg
end)

return systray

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
