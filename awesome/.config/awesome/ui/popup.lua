local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local helpers   = require("ui.helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--- {{{ System popup
--- https://github.com/1jss/awesome-lighter/
local screen     = screen.primary
local box_width  = dpi(128)
local box_height = dpi(128)

-- Icon of the widget {{{
local icon = helpers.svg(nil, nil, nil, "progressbar_fg")
icon.backlight_path_tail = "backlight/screen.svg"
-- }}}

-- Progress bar of the widget {{{
local bar = wibox.widget {
    widget = wibox.widget.progressbar,
    shape = gears.shape.rounded_bar,
    bar_shape = gears.shape.rounded_bar,
    color = beautiful.theme[theme_name].progressbar_fg,
    background_color = beautiful.theme[theme_name].progressbar_bg,
    max_value = 100,
    value = 0
}
-- Update the bar colors
awesome.connect_signal("theme_change", function(theme)
    bar.color = beautiful.theme[theme].progressbar_fg
    bar.background_color = beautiful.theme[theme].progressbar_bg
end)
-- }}}

-- The popup itself
local popup = wibox {
    x       = screen.geometry.width/2  - box_width/2,
    y       = 8*screen.geometry.height/10 - box_height/2,
    width   = box_width,
    height  = box_height,
    bg      = "#00000000", -- for anti-aliasing
    type    = "notification",
    visible = false,
    ontop   = true
}

-- Timer of the popup
popup.timer = gears.timer {
    timeout = 4,
    autostart = false,
    callback = function()
        popup.visible = false
    end
}

-- Show the widget
function popup:show()
    -- show on the correct screen
    local geometry = awful.screen.focused().geometry
    popup:geometry {
        x = geometry.x + geometry.width/2  - box_width/2,
        y = geometry.y + 8*geometry.height/10 - box_height/2
    }
    -- restart the timer
    popup.timer:again()
    -- show the popup widget
    popup.visible = true
end

-- Theme change
function popup:on_theme_change(state)
    if state == "day" then
        icon.backlight_path_tail = "backlight/screen.svg"
    else
        icon.backlight_path_tail = "backlight/screen-night.svg"
    end
    -- Popup not showed
end

-- Keyboard update
function popup:on_keyboard_update(percentage)
    bar.value = percentage

    if percentage == 0 then
        icon:load_image(beautiful.icon_path.."backlight/keyboard-off.svg")
    else
        icon:load_image(beautiful.icon_path.."backlight/keyboard.svg")
    end

    popup:show()
end

-- Screen update
function popup:on_screen_update(percentage)
    bar.value = percentage
    icon:update(nil, beautiful.icon_path..icon.backlight_path_tail)
    popup:show()
end

-- Blue light update
function popup:on_bluelight_update(percentage)
    bar.value = percentage
    icon:update(nil, beautiful.icon_path.."backlight/blue.svg")
    popup:show()
end

-- Exclude volume initialization
popup.volume_initialized = false

-- Volume update
function popup:on_volume_update(volume, muted)
    if not popup.volume_initialized then
        popup.volume_initialized = true
        return
    end

    bar.value = volume

    if muted then
        icon:update(nil, beautiful.icon_path.."/volume/volume-off.svg")
    elseif volume < 10 then
        icon:update(nil, beautiful.icon_path.."/volume/volume-low.svg")
    elseif volume < 60 then
        icon:update(nil, beautiful.icon_path.."/volume/volume-medium.svg")
    else
        icon:update(nil, beautiful.icon_path.."/volume/volume-high.svg")
    end

    popup:show()
end

-- Setting up the anti-aliased widget
local popup_widget = {
    {
        {
            icon,
            top    = dpi(35),
            bottom = dpi(40),
            left   = dpi(40),
            right  = dpi(40),
            widget = wibox.container.margin
        },
        {
            bar,
            top    = dpi(110),
            bottom = dpi(10),
            left   = dpi(10),
            right  = dpi(10),
            widget = wibox.container.margin
        },
        layout = wibox.layout.stack
    },
    layout = wibox.layout.fixed.vertical
}

popup:setup {
    helpers.themed(popup_widget, "bg"),
    shape  = gears.shape.rounded_rect,
    widget = wibox.container.background(),
    border_width = beautiful.border_width,
    border_color = beautiful.border_normal
}

-- Click actions
popup:buttons {
    awful.button {
        button = 1,
        on_press = function ()
            popup.timer:stop()
            popup.visible = false
        end
    }
}

-- Signal connection {{{
awesome.connect_signal("volume_change",
    function(volume, muted)
        popup:on_volume_update(volume, muted)
    end)

awesome.connect_signal("theme_change",
    function(state)
        popup:on_theme_change(state)
    end)

awesome.connect_signal("screen_backlight_change",
    function(percentage)
        popup:on_screen_update(percentage)
    end)

awesome.connect_signal("screen_bluelight_change",
    function(percentage)
        popup:on_bluelight_update(percentage)
    end)

awesome.connect_signal("keyboard_backlight_change",
    function(percentage)
        popup:on_keyboard_update(percentage)
    end)
-- }}}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
