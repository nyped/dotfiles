local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

return function(s)
    return wibox.widget({
        awful.widget.layoutbox({
            screen = s,
            buttons = {
                awful.button({}, 1, function()
                    awful.layout.inc(1)
                end),
                awful.button({}, 3, function()
                    awful.layout.inc(-1)
                end),
                awful.button({}, 4, function()
                    awful.layout.inc(1)
                end),
                awful.button({}, 5, function()
                    awful.layout.inc(-1)
                end),
            },
        }),
        top = beautiful.icon_v_padding,
        bottom = beautiful.icon_v_padding,
        right = beautiful.wibar_spacing,
        widget = wibox.container.margin,
    })
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
