local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local helpers = require("ui.helpers")
local dpi = beautiful.xresources.apply_dpi
local centered = helpers.centered
local padded = helpers.padded
local widgets = {}

-- {{{ Create a date widget using a format
local function date(format, fg_name, size)
    local widget = {
        format = helpers.markup_format(format, beautiful.font, size),
        refresh = 1,
        widget = wibox.widget.textclock,
    }
    return helpers.themed(widget, nil, fg_name)
end
-- }}}

-- {{{ Calendar
local calendar_widget = centered(padded({
    centered(date("%A", "day_name", 12)),
    centered({
        centered(date("%d", "day_number", 10)),
        centered(date("%b", "month_name", 10)),
        spacing = dpi(10),
        layout = wibox.layout.fixed.horizontal,
    }),
    spacing = dpi(5),
    layout = wibox.layout.fixed.vertical,
}, 20, 20))

local themed_calendar = helpers.themed(
    calendar_widget,
    "bg",
    nil,
    gears.shape.rounded_rect,
    beautiful.border_width
)

widgets.calendar = helpers.constraint(themed_calendar, dpi(100))
-- }}}

-- Weather {{{
local weather_text_widget = wibox.widget({
    markup = helpers.markup_format("unknown", beautiful.font, 10),
    align = "center",
    valigin = "center",
    widget = wibox.widget.textbox,
})

local weather_text = helpers.themed(weather_text_widget, nil, "weather_cond")

local weather_temperature_widget = wibox.widget({
    markup = helpers.markup_format("-", beautiful.font, 12)
        .. helpers.markup_format("°C", beautiful.font, 12),
    align = "center",
    valigin = "center",
    widget = wibox.widget.textbox,
})

local weather_temperature =
    helpers.themed(weather_temperature_widget, nil, "weather_temp")

local weather_icon_widget = wibox.widget({
    markup = helpers.markup_format("", beautiful.icon_font, 12),
    align = "center",
    valigin = "center",
    widget = wibox.widget.textbox,
})

local weather_icon = helpers.themed(weather_icon_widget, nil, "fg")

-- Weather update
awesome.connect_signal("weather_update", function(text, temperature, emoji)
    weather_text_widget:set_markup_silently(
        helpers.markup_format(text, beautiful.font, 10)
    )

    weather_temperature_widget:set_markup_silently(
        helpers.markup_format(temperature, beautiful.font, 12)
            .. helpers.markup_format("°C", beautiful.font, 12)
    )

    weather_icon.widget:set_markup_silently(
        helpers.markup_format(emoji, beautiful.icon_font, 12)
    )
end)

-- Update script
local weather_script = [[
    bash -c '
    fallback=":unknown:-";
    var=$(curl -s "wttr.in/paris?format=%c:%C:%t" 2>/dev/null);
    case "$var" in
      *HTML* | "" | *Unknown*)
        var="$fallback"
      ;;
    esac

    echo "$var"
    '
]]

local weather_widget = centered(padded({
    centered({
        weather_icon,
        weather_temperature,
        spacing = dpi(5),
        layout = wibox.layout.fixed.horizontal,
    }),
    weather_text,
    spacing = dpi(5),
    layout = wibox.layout.fixed.vertical,
}, 20, 20))

-- Final widget
local themed_weather = helpers.themed(
    weather_widget,
    "bg",
    nil,
    gears.shape.rounded_rect,
    beautiful.border_width
)

widgets.weather = helpers.constraint(themed_weather, dpi(100))

-- Update function
function widgets.weather:fetch_weather()
    awful.spawn.easy_async_with_shell(weather_script, function(stdout)
        local out = stdout:gsub("[\r\n]", "")
        local emoji, text, temp = out:match("(.+):(.+):(.+)")
        temp = temp:gsub("°C", "") -- remove trailing degree
        awesome.emit_signal("weather_update", text, temp, emoji)
    end)
end
-- }}}

-- {{{ Param line
local suspend_button = helpers.create_button_widget(
    "鈴",
    helpers.spawner("systemctl suspend"),
    helpers.spawner(script_path .. "lock")
)
-- TODO
local monitor_button = helpers.create_button_widget("类", function()
    awesome.emit_signal("monitors_show")
end)

-- Update theme button icon according to the current theme
local theme_button =
    helpers.create_button_widget("", helpers.spawner(script_path .. "color"))
awesome.connect_signal("theme_change", function(theme)
    local icon = theme == "day" and "" or ""
    theme_button.icon:set_markup_silently(
        helpers.markup_format(
            icon,
            beautiful.icon_font,
            theme_button.icon.font_size
        )
    )
end)

-- Notification mode button
local notif_button = helpers.create_button_widget("", function()
    awesome.emit_signal("notification::mode_toggle")
end)

awesome.connect_signal("notification::mode", function(focus, _)
    local icon = focus and "" or ""
    notif_button.icon:set_markup_silently(
        helpers.markup_format(
            icon,
            beautiful.icon_font,
            theme_button.icon.font_size
        )
    )
end)

widgets.param = wibox.widget({
    suspend_button,
    theme_button,
    monitor_button,
    notif_button,
    spacing = dpi(5),
    layout = wibox.layout.flex.horizontal,
})
-- }}}

return widgets

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
