local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local beautiful = require("beautiful")
local helpers = require("ui.helpers")
local widgets = require("ui.bar.widgets")

screen.connect_signal("request::desktop_decoration", function(s)
    -- {{{ tags
    for key, name in ipairs({
        "web",
        "search",
        "console",
        "doc",
        "chat",
        "video",
        "misc",
        "office",
        "music",
        "download",
    }) do
        awful.tag.add(name, {
            index = key,
            layout = awful.layout.suit.tile,
            screen = s,
        })
    end
    -- Default tag
    awful.tag.find_by_name(s, "web").selected = true
    -- }}}

    -- {{{ Create the wibox
    s.bar = awful.wibar({
        position = "top",
        screen = s,
    })
    s.bar:setup({
        {
            {
                {
                    { -- Left widgets
                        widgets.taglist(s),
                        widgets.class,
                        widgets.tasklist(s),
                        spacing = dpi(30),
                        layout = wibox.layout.fixed.horizontal,
                    },
                    { -- Middle widget
                        widgets.clock(),
                        widgets.notifications,
                        spacing = dpi(10),
                        layout = wibox.layout.fixed.horizontal,
                    },
                    { -- Right widgets
                        widgets.layoutbox(s),
                        widgets.hwmon,
                        widgets.systray,
                        widgets.brightness,
                        widgets.volume,
                        widgets.battery,
                        spacing = beautiful.wibar_item_spacing,
                        layout = wibox.layout.fixed.horizontal,
                    },
                    layout = wibox.layout.align.horizontal,
                    expand = "none",
                },
                -- Margins
                left = beautiful.wibar_padding,
                right = beautiful.wibar_padding + beautiful.icon_h_padding,
                widget = wibox.container.margin,
            },
            -- Dynamic theme wrapper
            widget = helpers.custom_container_bg("bar_bg", "bar_fg"),
        },
        -- Bottom border
        color = beautiful.border_normal,
        bottom = beautiful.border_width,
        widget = wibox.container.margin,
    })
    -- }}}
end)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
