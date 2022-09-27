local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("ui.helpers")

local notif_buttons = {
    awful.button({
        button = 1,
        on_press = function()
            awesome.emit_signal("notification::mode_toggle")
        end,
    }),
}
local notif_icon = helpers.svg({
    theme_var = "bar_fg",
    buttons = notif_buttons,
})
local notifications = wibox.widget({
    notif_icon,
    top = beautiful.icon_v_padding,
    bottom = beautiful.icon_v_padding,
    layout = wibox.container.margin,
    visible = false,
    new = 0,
})
-- Tooltip
helpers.tooltip(notifications, function()
    local number = tostring(notifications.new)
    if notifications.new == 1 then
        return number .. " new notification"
    elseif notifications.new > 1 then
        return number .. " new notifications"
    end
    return "No notification"
end)

awesome.connect_signal("notification::mode", function(silent, new)
    local status = new > 0 and "_new" or ""
    local mode = silent and "_off" or "_on"
    -- Update visibility
    if not silent and new <= 0 then
        notifications.visible = false
        return
    else
        notifications.visible = true
    end
    -- Updating tooltip data
    notifications.new = new
    -- Changing icons
    notif_icon:update(
        nil,
        beautiful.icon_path
            .. "notification/notification"
            .. mode
            .. status
            .. ".svg"
    )
end)

return notifications

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
