local beautiful = require("beautiful")
local wibox     = require("wibox")
local gears     = require("gears")
local awful     = require("awful")
local helpers   = require("helpers")
local screen    = screen.primary
local dpi       = beautiful.xresources.apply_dpi
local centered  = helpers.centered
local padded    = helpers.padded
local eq_padded = helpers.equal_padded

-- Create a date widget using a format
local function date(format, fg_name, size)
    local widget = {
        format  = helpers.markup_format(format, beautiful.font, size),
        refresh = 1,
        widget  = wibox.widget.textclock
    }

    return helpers.themed(widget, nil, fg_name)
end

-- {{{ Text clock
local textclock_widget = padded(centered {
    date("%I", "hour"),
    date("%M", "minute"),
    date('%S', "second"),
    date('%p', "meridiem"),
    spacing = dpi(5),
    layout  = wibox.layout.fixed.horizontal
}, 20, 20)

local textclock = helpers.themed(
        textclock_widget, "bg", nil,
        gears.shape.rounded_rect, beautiful.border_width)
-- }}}

-- {{{ Calendar
local calendar_widget = padded(
    centered {
        centered {
            centered(date("%d", "day_number")),
            centered(date("%b", "month_name", 12)),
            spacing = dpi(5),
            layout = wibox.layout.fixed.vertical
        },
        centered(date("%A", "day_name", 17)),
        spacing = dpi(20),
        layout = wibox.layout.fixed.horizontal
    },
    20, 20)

local calendar = helpers.themed(
        calendar_widget, "bg", nil,
        gears.shape.rounded_rect, beautiful.border_width)
-- }}}

-- Music widget {{{
local player_cover = wibox.widget {
    image   = beautiful.icon_path.."player/cover.png",
    resize  = true,
    buttons = { -- Raise or spawn Spotify if clicked on the image
        awful.button({}, 1, nil, function()
            -- TODO implement it
        end)
    },
    widget  = wibox.widget.imagebox
}

local button_previous  = helpers.create_button("玲",
                            helpers.spawner("playerctl previous"))
local button_next      = helpers.create_button("怜",
                            helpers.spawner("playerctl next"))
local button_stop_play = helpers.create_button("契",
                            helpers.spawner("playerctl play-pause"))

local player_buttons = centered {
    padded(button_previous),
    padded(button_stop_play),
    padded(button_next),
    expand  = "inside",
    spacing = dpi(5),
    layout  = wibox.layout.fixed.horizontal
}

local player_text_widget = wibox.widget {
    markup = helpers.markup_format("Not playing", beautiful.font, 9),
    align  = "center",
    valign = "center",
    ellipsize = "end",
    forced_height = dpi(12),
    widget = wibox.widget.textbox
}

local player_text = helpers.themed(player_text_widget, nil, "fg")

-- Text update
awesome.connect_signal("player_text_update", function(text)
    player_text_widget:set_markup_silently(
            helpers.markup_format(text, beautiful.font, 9))
end)

-- Cover update
awesome.connect_signal("player_cover_update", function(path)
    player_cover.image = gears.surface.load_uncached(path)
end)

-- Stop pause update
awesome.connect_signal("player_status_update", function(status)
    local symbol = status == "Playing" and "" or "契"

    button_stop_play.icon:set_markup_silently(
        helpers.markup_format(symbol, beautiful.icon_font, 20))
end)

local music_player_widget =
    centered {
        padded({
            player_cover,
            bg     = beautiful.theme[theme_name].bg,
            shape  = gears.shape.rounded_rect,
            widget = wibox.container.background,
            border_width = 0
        }, 20, 10, 20, 20),
        padded(player_text, 0, 0),
        padded(player_buttons),
        spacing = dpi(5),
        widget  = wibox.layout.fixed.vertical
    }

-- Final music player
local music_player = helpers.themed(
        music_player_widget, "bg", nil,
        gears.shape.rounded_rect, beautiful.border_width)
-- }}}

-- Weather {{{
local weather_text_widget = wibox.widget {
    markup  = helpers.markup_format("unknown", beautiful.font, 11),
    align   = "center",
    valigin = "center",
    widget  = wibox.widget.textbox
}

local weather_text = helpers.themed(weather_text_widget, nil, "weather_cond")

local weather_temperature_widget = wibox.widget {
    markup  = helpers.markup_format("-", beautiful.font, 20)
                ..helpers.markup_format("°C", beautiful.font, 18),
    align   = "center",
    valigin = "center",
    widget  = wibox.widget.textbox
}

local weather_temperature = helpers.themed(weather_temperature_widget, nil, "weather_temp")

local weather_icon_widget = wibox.widget {
    markup  = helpers.markup_format("", beautiful.icon_font, 20),
    align   = "center",
    valigin = "center",
    widget  = wibox.widget.textbox
}

local weather_icon = helpers.themed(weather_icon_widget, nil, "fg")

-- Weather update
awesome.connect_signal("weather_update", function(text, temperature, emoji)
    weather_text_widget:set_markup_silently(
        helpers.markup_format(text, beautiful.font, 11))

    weather_temperature_widget:set_markup_silently(
        helpers.markup_format(temperature, beautiful.font, 20)
            ..helpers.markup_format("°C", beautiful.font, 18))

    weather_icon.widget:set_markup_silently(
        helpers.markup_format(emoji, beautiful.icon_font, 20))
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

-- Update function
local function fetch_weather()
    awful.spawn.easy_async_with_shell(
        weather_script,
        function(stdout)
            local out = stdout:gsub("[\r\n]", "")
            local emoji, text, temp = out:match("(.+):(.+):(.+)")
            temp = temp:gsub("°C", "") -- remove trailing degree
            awesome.emit_signal("weather_update", text, temp, emoji)
        end)
end

local weather_widget =
    centered(padded({
        centered {
            weather_icon,
            weather_temperature,
            spacing = dpi(20),
            layout = wibox.layout.fixed.horizontal
        },
        weather_text,
        spacing = dpi(5),
        layout = wibox.layout.fixed.vertical
    }, 20, 20))

-- Final widget
local weather = helpers.themed(
        weather_widget, "bg", nil,
        gears.shape.rounded_rect, beautiful.border_width)
-- }}}

-- {{{ Monitor configuration popup
local monitor_popup_height = dpi(100)
local monitor_popup_width  = dpi(300)

local monitor_popup = wibox {
    screen  = screen,
    x       = 50, -- Junk values
    y       = 50, -- Will be set later
    width   = monitor_popup_width,
    height  = monitor_popup_height,
    bg      = "#00000000", -- for anti-aliasing
    type    = "notification",
    visible = false,
    ontop   = true
}

local monohead  = helpers.create_button_widget("",
                        helpers.spawner(script_path.."monitors -l"))
local external  = helpers.create_button_widget("",
                        helpers.spawner(script_path.."monitors -d"))
local multihead = helpers.create_button_widget("",
                        helpers.spawner(script_path.."monitors -m"))

local monitors_line = {
    monohead,
    external,
    multihead,
    spacing = dpi(5),
    layout = wibox.layout.flex.horizontal
}

monitor_popup:setup {
    monitors_line,
    bg     = beautiful.transparent,
    widget = wibox.container.background,
    border_width = 0 -- we just want the compositor shadow
}

-- Leaving with window closes it
monitor_popup:connect_signal("mouse::leave",
    function() monitor_popup.visible = false end)

-- Toggling the setting window
function monitor_popup:toggle()
    -- show on the correct screen
    local geometry = awful.screen.focused().geometry
    monitor_popup:geometry {
        x = geometry.x + geometry.width/2  - monitor_popup_width/2,
        y = geometry.y + geometry.height/2 - monitor_popup_height/2
    }

    -- Toggle it now
    monitor_popup.visible = not monitor_popup.visible
end
-- }}}

-- {{{ Button line
local suspend  = helpers.create_button_widget("鈴",
                        helpers.spawner("systemctl suspend"))
local theme    = helpers.create_button_widget("",
                        helpers.spawner(script_path.."color"))
local monitors = helpers.create_button_widget("类",
                        function() monitor_popup:toggle() end)

-- Update theme button icon according to the current theme
local theme_icon = theme.icon
awesome.connect_signal("theme_change", function(theme)
    local icon = theme == "day" and "" or ""
    theme_icon:set_markup_silently(
        helpers.markup_format(icon, beautiful.icon_font, 20))
end)

local button_line = {
    suspend,
    theme,
    monitors,
    spacing = dpi(5),
    layout = wibox.layout.flex.horizontal
}
-- }}}

-- {{{ Final panel
local panel_width = dpi(250)
local panel_heigth = dpi(700)

local panel = wibox {
    screen  = screen,
    x       = 50, -- Junk values
    y       = 50, -- Will be set later mebbe
    width   = panel_width,
    height  = panel_heigth,
    bg      = "#00000000", -- for anti-aliasing
    type    = "popup_menu",
    visible = false,
    ontop   = true
}

-- Setting up the anti-aliased widget
local panel_widget = wibox.widget {
    eq_padded(textclock, dpi(2.5)),
    eq_padded(music_player, dpi(2.5)),
    eq_padded(calendar, dpi(2.5)),
    eq_padded(weather, dpi(2.5)),
    eq_padded(button_line, dpi(2.5)),
    layout = wibox.layout.ratio.vertical
}

local panel_ratio = {0.15, 0.45, 0.15, 0.15, 0.1}
for i=1, 5 do
    panel_widget:set_ratio(i, panel_ratio[i])
end

panel:setup {
    panel_widget,
    bg     = beautiful.transparent,
    widget = wibox.container.background(),
    border_width = 0 -- we just want the compositor shadow
}

-- CLick actions
panel:connect_signal("mouse::leave",
    function ()
        panel.visible = false
    end)

-- Toggling method
function panel:toggle()
    -- show on the correct screen
    local geometry = awful.screen.focused().geometry
    panel:geometry {
        x = geometry.x + 50,
        y = geometry.y + geometry.height/2 - panel_heigth/2
    }

    -- Update metadata
    fetch_weather()

    -- Toggle it
    panel.visible = not panel.visible
end

-- Hide when workspace switch
tag.connect_signal("property::selected", function(_)
    panel.visible = false
end)
-- }}}

return panel

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
