local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local hwmon_widget = awful.widget.watch(
    [[
        bash -c 'cat \
            /sys/devices/platform/applesmc.768/temp13_input \
            /sys/devices/platform/dell_smm_hwmon/hwmon/hwmon?/temp2_input \
            /sys/devices/platform/applesmc.768/fan1_input \
            /sys/devices/platform/dell_smm_hwmon/hwmon/hwmon?/fan1_input'
    ]],
    5,
    function(widget, stdout)
        local out = stdout:gsub("[\n\r]", " ")
        local temp, fan = out:match("(.+)[\n\r ]+(.+)")
        local temp_str, fan_str

        if fan ~= "0 " then
            fan_str = "   " .. fan .. "<span weight='bold'>rpm</span>"
        else
            fan_str = ""
        end
        temp_str = tostring(math.floor(tonumber(temp) / 1000))
            .. "<span weight='bold'>°c</span>"

        widget:set_markup_silently(temp_str .. fan_str)
    end,
    wibox.widget.textbox()
)

local hwmon = {
    hwmon_widget,
    top = beautiful.icon_v_padding,
    bottom = beautiful.icon_v_padding,
    layout = wibox.container.margin,
}

return hwmon

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
