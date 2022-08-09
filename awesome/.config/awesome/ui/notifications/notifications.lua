local ruled = require("ruled")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local center = require("ui.control_center.control_center")
local notification_template =
    require("ui.notifications.utils").notification_template

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
            position = "bottom_right",
            screen = awful.screen.preferred,
            timeout = 10,
            margin = dpi(5),
            border_width = dpi(1),
            implicit_timeout = 5,
        },
    })
end)
-- }}}

-- {{{ Custom notification layout
naughty.connect_signal("request::display", function(n)
    -- Add it to the notif center
    center:add(n)

    -- Skip if the center is opened
    if center.visible or center.focus then
        return naughty.destroy(n)
    end

    local notif = naughty.layout.box({
        notification = n,
        type = "notification",
        screen = awful.screen.focused(),
        shape = gears.shape.rectangle,
        bg = "transparent",
        widget_template = notification_template(n),
    })

    -- Custom buttons
    notif:buttons({
        awful.button({}, 2, function()
            naughty.destroy(n)
        end),
        awful.button({}, 3, function()
            naughty.destroy(n)
            center:remove(n)
        end),
    })

    -- Disable timeout on hover
    notif:connect_signal("mouse::enter", function()
        n:reset_timeout(1000)
    end)

    -- Restore timer
    notif:connect_signal("mouse::leave", function()
        n:reset_timeout(10)
    end)
end)
-- }}}

-- {{{ Focus mode
awesome.connect_signal("notification::mode_toggle", function()
    naughty.destroy_all_notifications()
    center.focus = not center.focus
    center.emit_state()
end)
-- }}}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
