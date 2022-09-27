local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local wibox = require("wibox")
local helpers = require("ui.helpers")

local battery_icon = helpers.svg({ theme_var = "bar_fg" })
battery_icon.current_icon = 10

local battery_level = wibox.widget({
    markup = "50<b>%</b>",
    widget = wibox.widget.textbox,
})

local bat = wibox.widget({
    {
        battery_icon,
        battery_level,
        spacing = dpi(5),
        layout = wibox.layout.fixed.horizontal,
    },
    top = beautiful.icon_v_padding,
    bottom = beautiful.icon_v_padding,
    layout = wibox.container.margin,
})

function bat:update_meta(charging, capacity_str)
    local capacity = tonumber(capacity_str)
    local image

    battery_level:set_markup_silently(capacity_str .. "%")

    if capacity >= 100 then
        -- Full
        image = beautiful.icon_path .. "battery/battery-100.svg"
        battery_level:set_markup_silently("")
    elseif charging then
        -- Charging
        image = beautiful.icon_path
            .. "battery/battery-charging-"
            .. tostring(battery_icon.current_icon)
            .. ".svg"
        battery_icon.current_icon = battery_icon.current_icon > 90 and 10
            or (battery_icon.current_icon + 10)
    else
        -- Discharging
        image = beautiful.icon_path
            .. "battery/battery-"
            .. tostring(math.ceil(capacity / 10) * 10)
            .. ".svg"
    end

    battery_icon.image = image
end

local battery = awful.widget.watch(
    "cat /sys/class/power_supply/BAT0/capacity "
        .. "/sys/class/power_supply/BAT0/status",
    1,
    function(widget, stdout)
        local capacity_str, status, charging

        capacity_str = stdout:match("(%d+)")
        status = stdout:match("([a-zA-Z]+)")
        charging = status == "Charging" and true or false
        widget:update_meta(charging, capacity_str)
    end,
    bat
)

return battery

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
