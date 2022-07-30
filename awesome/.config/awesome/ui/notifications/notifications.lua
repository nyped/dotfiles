local ruled = require("ruled")
local awful = require("awful")
local naughty = require("naughty")
local helpers = require("ui.helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification({
        urgency = "critical",
        title = "Oops, an error happened"
            .. (startup and " during startup!" or "!"),
        message = message,
    })
end)
-- }}}

-- {{{ Notifications default settings
ruled.notification.connect_signal("request::rules", function()
    ruled.notification.append_rule({
        rule = {},
        properties = {
            ontop = true,
            position = "top_right",
            screen = awful.screen.preferred,
            timeout = 10,
            margin = dpi(5),
            border_width = dpi(1),
            implicit_timeout = 5,
        },
    })
end)
-- }}}

-- {{{ Player for spotify notifications
local button_previous =
    helpers.create_button("玲", helpers.spawner("playerctl previous"))
local button_next =
    helpers.create_button("怜", helpers.spawner("playerctl next"))
local button_stop_play =
    helpers.create_button("契", helpers.spawner("playerctl play-pause"))

local icons_player = {
    helpers.padded(button_previous),
    helpers.padded(button_stop_play),
    helpers.padded(button_next),
    expand = "inside",
    spacing = dpi(5),
    layout = wibox.layout.fixed.horizontal,
}

-- Stop pause update
awesome.connect_signal("player_status_update", function(status)
    local symbol = status == "Playing" and "" or "契"

    button_stop_play.icon:set_markup_silently(
        helpers.markup_format(symbol, beautiful.icon_font, 20)
    )
end)
-- }}}

-- {{{ Custom notification templace
local function notification_template(notif)
    local action_template = {
        {
            {
                nil,
                {
                    id = "text_role",
                    widget = wibox.widget.textbox,
                },
                nil,
                expand = "outside",
                widget = wibox.layout.align.horizontal,
            },
            top = dpi(5),
            bottom = dpi(5),
            left = dpi(10),
            right = dpi(10),
            widget = wibox.container.margin,
            forced_width = dpi(150),
        },
        shape = gears.shape.rounded_rect,
        border_width = 1,
        border_color = beautiful.border_normal,
        widget = wibox.container.background,
    }

    local actions
    if notif.app_name == "Spotify" then
        -- Force custom action for spotify
        actions = icons_player
    else
        -- Other apps actions
        actions = wibox.widget({
            notification = notif,
            widget_template = action_template,
            base_layout = wibox.widget({
                spacing = dpi(3),
                layout = wibox.layout.flex.vertical,
            }),
            style = {
                underline_normal = false,
                underline_selected = true,
            },
            widget = naughty.list.actions,
        })
    end

    local icon
    if notif.icon == nil then
        local icon_name
        if
            notif.app_name == "network"
            or notif.app_name == "NetworkManager"
        then
            icon_name = "notification/network.svg"
        else
            icon_name = "notification/bell.svg"
        end
        local dim = beautiful.notification_icon_size / 2
        icon = helpers.svg(beautiful.icon_path .. icon_name, dim, dim)
    else
        icon = naughty.widget.icon
    end

    return {
        {
            {
                {
                    {
                        { -- icon
                            icon,
                            shape = gears.shape.rounded_rect,
                            widget = wibox.container.background,
                        },
                        valign = "center",
                        widget = wibox.container.place,
                    },
                    {
                        { -- title
                            nil,
                            helpers.themed(naughty.widget.title, nil, "fg"),
                            nil,
                            expand = "outside",
                            layout = wibox.layout.align.horizontal,
                        },
                        { -- message
                            nil,
                            helpers.themed(naughty.widget.message, nil, "fg"),
                            nil,
                            expand = "outside",
                            layout = wibox.layout.align.horizontal,
                        }, -- actions
                        helpers.centered(actions),
                        spacing = 4,
                        expand = "inside",
                        layout = wibox.layout.align.vertical,
                    },
                    fill_space = true,
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.horizontal,
                },
                margins = beautiful.notification_margin,
                widget = wibox.container.margin,
                forced_width = dpi(400),
            },
            strategy = "min",
            height = dpi(110),
            widget = wibox.container.constraint,
        }, -- antialiasing
        shape = gears.shape.rounded_rect,
        widget = helpers.custom_container_bg("bg", "fg"), -- bg updated according to the theme
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
    }
end
-- }}} notification_template(notif)

-- {{{ Custom notification layout
naughty.connect_signal("request::display", function(n)
    local notif = naughty.layout.box({
        notification = n,
        type = "notification",
        screen = awful.screen.focused(),
        shape = gears.shape.rectangle,
        bg = "transparent",
        widget_template = notification_template(n),
    })

    -- Custom buttons
    notif:buttons(
        gears.table.join(
            awful.button({}, 1, function() end),
            awful.button({}, 3, function()
                naughty.destroy(n)
            end)
        )
    )

    -- Disable timeout on hover
    notif:connect_signal("mouse::enter", function()
        n:reset_timeout(1000)
    end)
end)
-- }}}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
