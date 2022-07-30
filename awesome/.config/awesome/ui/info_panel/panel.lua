local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local eq_padded = require("ui.helpers").equal_padded
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local widgets   = require("ui.info_panel.widgets")
local helpers   = require("ui.helpers")

local panel_height = dpi(600)
local panel_width  = dpi(250)

local panel = wibox {
    x       = 50, -- dummy
    y       = 50, -- values
    width   = panel_width,
    height  = panel_height,
    bg      = "transparent", -- for anti-aliasing
    type    = "popup_menu",
    visible = false,
    ontop   = true
}

-- Setting up the anti-aliased widget
local panel_widgets = wibox.widget {
    eq_padded(widgets.player,   dpi(2.5)),
    eq_padded(widgets.calendar, dpi(2.5)),
    eq_padded(widgets.weather,  dpi(2.5)),
    eq_padded(widgets.param,    dpi(2.5)),
    layout = wibox.layout.fixed.vertical
}

local final_widgets = helpers.centered(
    helpers.equal_padded(panel_widgets, dpi(2.5)))

local frame = wibox.widget {
    final_widgets,
    widget = helpers.custom_container_bg("bg_alt", "fg"),
    shape  = gears.shape.rounded_rect,
    border_width = beautiful.border_width,
    border_color = beautiful.border_normal
}

panel:setup {
    frame,
    bg     = "transparent",
    widget = wibox.container.background,
    border_width = 0 -- we just want the compositor shadow
}

-- Click actions
panel:connect_signal("mouse::leave", function() panel.visible = false end)

-- Toggling method
function panel:toggle()
    -- Show on the correct screen
    local geometry = awful.screen.focused().geometry
    panel:geometry {
        x = geometry.x + dpi(5),
        y = geometry.y + dpi(5) + geometry.height/2 - panel_height/2,
    }
    -- Fetch weather
    widgets.weather:fetch_weather()
    -- Toggle it
    panel.visible = not panel.visible
end

-- Hide when workspace switch
tag.connect_signal("property::selected", function(_)
    panel.visible = false
end)

awesome.connect_signal("panel_toggle", panel.toggle)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
