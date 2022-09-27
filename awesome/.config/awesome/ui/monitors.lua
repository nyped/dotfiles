local helpers = require("ui.helpers")
local wibox = require("wibox")
local awful = require("awful")
local dpi = require("beautiful.xresources").apply_dpi

-- {{{ Monitor configuration popup
local monitor_popup_height = dpi(100)
local monitor_popup_width = dpi(400)

local monitor_popup = wibox({
    x = 50, -- Junk values
    y = 50, -- Will be set later
    width = monitor_popup_width,
    height = monitor_popup_height,
    bg = "transparent", -- for anti-aliasing
    type = "notification",
    visible = false,
    ontop = true,
})

local monohead = helpers.create_button_widget(
    "",
    helpers.spawner(script_path .. "monitors -l"),
    nil,
    20
)
local external = helpers.create_button_widget(
    "",
    helpers.spawner(script_path .. "monitors -d"),
    nil,
    20
)
local multihead = helpers.create_button_widget(
    "",
    helpers.spawner(script_path .. "monitors -m"),
    nil,
    20
)
local replicate = helpers.create_button_widget(
    "",
    helpers.spawner(script_path .. "monitors -r"),
    nil,
    20
)

local monitors_line = {
    monohead,
    external,
    multihead,
    replicate,
    spacing = dpi(5),
    layout = wibox.layout.flex.horizontal,
}

monitor_popup:setup({
    monitors_line,
    bg = "transparent",
    widget = wibox.container.background,
    border_width = 0, -- we just want the compositor shadow
})

-- Leaving with window closes it
monitor_popup:connect_signal("mouse::leave", function()
    monitor_popup.visible = false
end)

-- Toggling the setting window
function monitor_popup:toggle()
    -- show on the correct screen
    local geometry = awful.screen.focused().geometry
    monitor_popup:geometry({
        x = geometry.x + geometry.width / 2 - monitor_popup_width / 2,
        y = geometry.y + geometry.height / 2 - monitor_popup_height / 2,
    })

    -- Toggle it now
    monitor_popup.visible = not monitor_popup.visible
end
-- }}}

awesome.connect_signal("monitors_show", function()
    monitor_popup:toggle()
end)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80