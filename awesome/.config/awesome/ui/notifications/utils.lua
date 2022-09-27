local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local helpers = require("ui.helpers")
local self = {}

local button_previous = helpers.create_button(
    "玲",
    helpers.spawner("playerctl previous -p spotify")
)
local button_next =
    helpers.create_button("怜", helpers.spawner("playerctl next -p spotify"))
local button_stop_play = helpers.create_button(
    "契",
    helpers.spawner("playerctl play-pause -p spotify")
)

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
--

function self.player_template(notif)
    local image = notif == nil and player_cover or notif.image
    local title = notif == nil and player_title or notif.title
    local message = notif == nil and player_info or notif.text
    return {
        {
            helpers.centered({
                helpers.centered({
                    {
                        { -- album art
                            image = image,
                            notification = notif,
                            resize = true,
                            forced_width = dpi(150),
                            forced_height = dpi(150),
                            widget = naughty.widget.icon,
                        },
                        border_width = 0,
                        shape = gears.shape.rounded_rect,
                        widget = wibox.container.background,
                    },
                    top = dpi(15),
                    widget = wibox.container.margin,
                }),
                helpers.centered({ -- song title
                    align = "center",
                    valign = "center",
                    ellipsize = "end",
                    forced_height = dpi(15),
                    text = title,
                    notification = notif,
                    widget = naughty.widget.title,
                }),
                helpers.centered({ -- album
                    align = "center",
                    valign = "center",
                    ellipsize = "end",
                    forced_height = dpi(15),
                    text = message,
                    notification = notif,
                    widget = naughty.widget.message,
                }),
                helpers.centered(icons_player), -- buttons
                spacing = dpi(5),
                widget = wibox.layout.fixed.vertical,
            }),
            strategy = "min",
            height = dpi(275),
            widget = wibox.container.constraint,
        },
        shape = gears.shape.rounded_rect,
        widget = helpers.custom_container_bg("bg", "fg"),
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
    }
end

function self.notification_template(notif)
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
        icon = helpers.svg({
            icon = beautiful.icon_path .. icon_name,
            height = dim,
            width = dim,
        })
    else
        icon = naughty.widget.icon({ notification = notif })
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
                            helpers.themed(
                                naughty.widget.title({ notification = notif }),
                                nil,
                                "fg"
                            ),
                            nil,
                            expand = "outside",
                            layout = wibox.layout.align.horizontal,
                        },
                        { -- message
                            nil,
                            helpers.themed(
                                naughty.widget.message({ notification = notif }),
                                nil,
                                "fg"
                            ),
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

return self

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
