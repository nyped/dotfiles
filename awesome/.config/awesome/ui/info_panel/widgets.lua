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

-- {{{ Text clock
local clock_widget = padded(
    centered({
        date("%I", "hour"),
        date("%M", "minute"),
        date("%S", "second"),
        date("%p", "meridiem"),
        spacing = dpi(5),
        layout = wibox.layout.fixed.horizontal,
    }),
    20,
    20
)

widgets.clock = helpers.themed(
    clock_widget,
    "bg",
    nil,
    gears.shape.rounded_rect,
    beautiful.border_width
)
-- }}}

-- {{{ Calendar
local calendar_widget = padded(
    centered({
        centered({
            centered(date("%d", "day_number")),
            centered(date("%b", "month_name", 12)),
            spacing = dpi(5),
            layout = wibox.layout.fixed.vertical,
        }),
        centered(date("%A", "day_name", 17)),
        spacing = dpi(20),
        layout = wibox.layout.fixed.horizontal,
    }),
    20,
    20
)

widgets.calendar = helpers.themed(
    calendar_widget,
    "bg",
    nil,
    gears.shape.rounded_rect,
    beautiful.border_width
)
-- }}}

-- Music widget {{{
local player_cover = wibox.widget({
    image = beautiful.icon_path .. "player/cover.png",
    resize = true,
    buttons = { -- Raise or spawn Spotify if clicked on the image
        awful.button({}, 1, nil, function()
            -- TODO implement it
        end),
    },
    widget = wibox.widget.imagebox,
})

local button_previous =
    helpers.create_button("玲", helpers.spawner("playerctl previous"))
local button_next =
    helpers.create_button("怜", helpers.spawner("playerctl next"))
local button_stop_play =
    helpers.create_button("契", helpers.spawner("playerctl play-pause"))

local player_buttons = centered({
    padded(button_previous),
    padded(button_stop_play),
    padded(button_next),
    expand = "inside",
    spacing = dpi(5),
    layout = wibox.layout.fixed.horizontal,
})

local player_text_widget = wibox.widget({
    markup = helpers.markup_format("Not playing", beautiful.font, 9),
    align = "center",
    valign = "center",
    ellipsize = "end",
    forced_height = dpi(12),
    widget = wibox.widget.textbox,
})

local player_text = helpers.themed(player_text_widget, nil, "fg")

-- Text update
awesome.connect_signal("player_text_update", function(text)
    player_text_widget:set_markup_silently(
        helpers.markup_format(text, beautiful.font, 9)
    )
end)

-- Cover update
awesome.connect_signal("player_cover_update", function(path)
    player_cover.image = gears.surface.load_uncached(path)
end)

-- Stop pause update
awesome.connect_signal("player_status_update", function(status)
    local symbol = status == "Playing" and "" or "契"

    button_stop_play.icon:set_markup_silently(
        helpers.markup_format(symbol, beautiful.icon_font, 20)
    )
end)

local player_widget = centered({
    padded({
        player_cover,
        bg = beautiful.theme[theme_name].bg,
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background,
        border_width = 0,
    }, 20, 10, 20, 20),
    padded(player_text, 0, 0),
    padded(player_buttons),
    spacing = dpi(5),
    widget = wibox.layout.fixed.vertical,
})

-- Final music player
widgets.player = helpers.themed(
    player_widget,
    "bg",
    nil,
    gears.shape.rounded_rect,
    beautiful.border_width
)
-- }}}

-- Weather {{{
local weather_text_widget = wibox.widget({
    markup = helpers.markup_format("unknown", beautiful.font, 11),
    align = "center",
    valigin = "center",
    widget = wibox.widget.textbox,
})

local weather_text = helpers.themed(weather_text_widget, nil, "weather_cond")

local weather_temperature_widget = wibox.widget({
    markup = helpers.markup_format("-", beautiful.font, 20)
        .. helpers.markup_format("°C", beautiful.font, 18),
    align = "center",
    valigin = "center",
    widget = wibox.widget.textbox,
})

local weather_temperature =
    helpers.themed(weather_temperature_widget, nil, "weather_temp")

local weather_icon_widget = wibox.widget({
    markup = helpers.markup_format("", beautiful.icon_font, 20),
    align = "center",
    valigin = "center",
    widget = wibox.widget.textbox,
})

local weather_icon = helpers.themed(weather_icon_widget, nil, "fg")

-- Weather update
awesome.connect_signal("weather_update", function(text, temperature, emoji)
    weather_text_widget:set_markup_silently(
        helpers.markup_format(text, beautiful.font, 11)
    )

    weather_temperature_widget:set_markup_silently(
        helpers.markup_format(temperature, beautiful.font, 20)
            .. helpers.markup_format("°C", beautiful.font, 18)
    )

    weather_icon.widget:set_markup_silently(
        helpers.markup_format(emoji, beautiful.icon_font, 20)
    )
end)

-- Update script
weather_script = [[
    bash -c '
    fallback=":unknown:-";
    var=$(curl -s "wttr.in/grenoble?format=%c:%C:%t" 2>/dev/null);
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
        spacing = dpi(20),
        layout = wibox.layout.fixed.horizontal,
    }),
    weather_text,
    spacing = dpi(5),
    layout = wibox.layout.fixed.vertical,
}, 20, 20))

-- Final widget
widgets.weather = helpers.themed(
    weather_widget,
    "bg",
    nil,
    gears.shape.rounded_rect,
    beautiful.border_width
)

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

-- {{{ Button line
local monitor_popup = require("ui.info_panel.monitors")

local suspend = helpers.create_button_widget(
    "鈴",
    helpers.spawner("systemctl suspend"),
    helpers.spawner(script_path .. "lock")
)
local theme =
    helpers.create_button_widget("", helpers.spawner(script_path .. "color"))
local monitors = helpers.create_button_widget("类", function()
    monitor_popup:toggle()
end)

-- Update theme button icon according to the current theme
local theme_icon = theme.icon
awesome.connect_signal("theme_change", function(theme)
    local icon = theme == "day" and "" or ""
    theme_icon:set_markup_silently(
        helpers.markup_format(icon, beautiful.icon_font, 20)
    )
end)

widgets.param = {
    suspend,
    theme,
    monitors,
    spacing = dpi(5),
    layout = wibox.layout.flex.horizontal,
}
-- }}}

return widgets

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
