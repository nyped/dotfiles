local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi


--- {{{ System popup
--- https://github.com/1jss/awesome-lighter/

local screen     = awful.screen.focused()
local box_width  = dpi(128)
local box_height = dpi(128)

local icon = wibox.widget {
    widget = wibox.widget.imagebox,
    backlight_path_tail = "backlight/screen.png",
    set_path_backlight = function(self, state)
        if state == "day" then
            self.backlight_path_tail = "backlight/screen-night.png"
        else
            self.backlight_path_tail = "backlight/screen.png"
        end

    end
}

local bar = wibox.widget{
    widget = wibox.widget.progressbar,
    shape = gears.shape.rounded_bar,
    color = beautiful.hud_slider_fg,
    background_color = beautiful.popup_bg,
    max_value = 100,
    value = 0
}

local popup = wibox({
    border_color = beautiful.popup_border,
    border_width = 1,
    screen  = awful.screen.focused(),
    x        = screen.geometry.width/2  - box_width/2,
    y        = 8*screen.geometry.height/10 - box_height/2,
    width   = box_width,
    height  = box_height,
    bg      = beautiful.popup_bg,
    visible = false,
    ontop   = true,
})

popup:setup {
    {
        icon,
        top    = dpi(25),
        bottom = dpi(30),
        left   = dpi(30),
        right  = dpi(30),
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
}

local timer = gears.timer {
    timeout = 4,
    autostart = false,
    callback = function()
        popup.visible = false
    end
}

popup:buttons {
    awful.button {
        button = 1,
        on_press = function ()
            popup.visible = false
            timer:stop()
        end
    }
}

-- {{{ Volume popup
local volume_initialized = false

awesome.connect_signal("volume_change",
    function(volume, muted)
        if not volume_initialized then
            volume_initialized = true
            return
        end

        bar.value = volume

        if muted then
            if volume < 20 then
                icon:set_image(beautiful.icon_path.."/volume/volume-variant-off.png")
            else
                icon:set_image(beautiful.icon_path.."/volume/volume-off.png")
            end
        elseif volume < 10 then
            icon:set_image(beautiful.icon_path.."/volume/volume-low.png")
        elseif volume < 60 then
            icon:set_image(beautiful.icon_path.."/volume/volume-medium.png")
        else
            icon:set_image(beautiful.icon_path.."/volume/volume-high.png")
        end

        if popup.visible then
            timer:again()
        else
            popup.visible = true
            timer:start()
        end
    end
)
-- }}}

-- {{{ Screen backlight popup
awesome.connect_signal("temperature_change",
    function(state)
        icon:set_path_backlight(state)
    end
)

awesome.connect_signal("screen_backlight_change",
    function(percentage)
        bar.value = percentage
        icon:set_image(beautiful.icon_path .. icon.backlight_path_tail)

        if popup.visible then
            timer:again()
        else
            popup.visible = true
            timer:start()
        end
    end
)
-- }}}

-- {{{ Keyboard backlight popup
awesome.connect_signal("keyboard_backlight_change",
    function(percentage)
        bar.value = percentage

        if percentage == 0 then
            icon:set_image(beautiful.icon_path.."backlight/keyboard-off.png")
        else
            icon:set_image(beautiful.icon_path.."backlight/keyboard.png")
        end

        if popup.visible then
            timer:again()
        else
            popup.visible = true
            timer:start()
        end
    end
)
-- }}}

-- }}}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
