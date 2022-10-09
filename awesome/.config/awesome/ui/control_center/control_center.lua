local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("ui.helpers")
local widgets = require("ui.control_center.widgets")
local naughty = require("naughty")
local utils = require("ui.notifications.utils")
local template = utils.notification_template

-- accessible state
local ret = {
    visible = false,
    unseen = 0,
    focus = false,
}

-- {{{ Send state signal
function ret.emit_state()
    awesome.emit_signal("notification::mode", ret.focus, ret.unseen)
end
-- }}}

-- dimensions
local center_height = dpi(575)
local center_width = dpi(300)

local center = wibox({
    x = 50, -- dummy
    y = 50, -- values
    width = center_width,
    height = center_height,
    bg = "transparent", -- for anti-aliasing
    type = "popup_menu",
    visible = ret.visible,
    ontop = true,
})

local center_widget = wibox.widget({
    layout = require("ui.control_center.overflow").vertical,
    forced_width = center_width,
    scrollbar_enabled = false,
    step = 100,
    spacing = dpi(5),
})

function center:clean()
    center_widget:reset()
    center_widget:add(widgets.cover)
    center_widget:add(widgets.player_infos)
    center_widget:add(widgets.day_infos)
    center_widget:add(widgets.param)
    ret.unseen = 0
    ret.emit_state()
end

-- init
center:clean()
-- }}}

-- {{{ Add/remove a notification
function ret:add(notif)
    local notif_box

    if notif.app_name == "Spotify" then
        return
    end

    notif_box = wibox.widget(template(notif))

    if not ret.visible then
        ret.unseen = ret.unseen + 1
        ret.emit_state()
    end

    -- Adding close button
    notif_box.close_func = function()
        local index = center_widget:index(notif_box)
        center_widget:remove(index)
        ret.unseen = math.max(0, ret.unseen - 1)
        ret.emit_state()
        -- Adjusting the anchor
        if #center_widget.children == 4 then
            center_widget.scroll_factor = 0
        end
    end

    notif_box:buttons({
        awful.button({
            button = 3,
            on_press = notif_box.close_func,
        }),
    })

    -- Insertion
    center_widget:insert(1, notif_box)

    notif.notif_box = notif_box
end

function ret:remove(notif)
    if notif.notif_box and notif.notif_box.close_func then
        notif.notif_box.close_func()
    end
end
-- }}}

local frame = wibox.widget({
    helpers.padded(center_widget, nil, nil, dpi(10), dpi(10)),
    widget = helpers.custom_container_bg("bg_alt", "fg"),
    shape = gears.shape.rounded_rect,
    border_width = beautiful.border_width,
    border_color = beautiful.border_normal,
})

center:setup({
    frame,
    bg = "transparent",
    widget = wibox.container.background,
    border_width = 0, -- we just want the compositor shadow
})

-- Toggling method
function center:toggle()
    -- Close all displayed notifications
    if not center.visible then
        naughty.destroy_all_notifications()
    end

    -- Fetch weather
    widgets.weather:fetch_weather()

    -- Show on the correct screen
    local geometry = awful.screen.focused().geometry
    center:geometry({
        x = geometry.x + dpi(5),
        y = geometry.y + dpi(5) + geometry.height / 2 - center_height / 2,
    })
    -- Toggle it
    ret.visible = not ret.visible
    center.visible = ret.visible

    if ret.visible then
        ret.unseen = 0
        ret.emit_state()
    end
end

awesome.connect_signal("control_center::toggle", center.toggle)
center:connect_signal("mouse::leave", center.toggle)

return ret

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
