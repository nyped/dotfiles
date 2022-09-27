local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("ui.helpers")
local spawn_media = require("tools.media").spawn_media

-- Blue light on laptop
local bluelevel_laptop = 100 -- init
local temp_min, temp_max = 4500, 6500 --

local function update_bluelevel_laptop(percentage_inc)
    -- Update the percentage
    bluelevel_laptop =
        math.min(100, math.max(0, bluelevel_laptop + percentage_inc))

    local inc = (temp_max - temp_min) / 100
    local val = tostring(4500 + bluelevel_laptop * inc)

    -- Update + events
    awful.spawn("redshift -m randr:crtc=0 -P -O " .. val)
    awesome.emit_signal("screen_bluelight_change", bluelevel_laptop)
end

-- Monitor test
local function is_builtin_output()
    local out = awful.screen.focused().outputs
    return out["LVDS"] or out["LVDS1"] or out["eDP"]
end

local brightness_buttons = {
    awful.button({
        button = 5,
        on_press = function()
            if not is_builtin_output() then
                spawn_media(
                    script_path .. "backlight -m -d 5%",
                    "screen_backlight_change"
                )
            else
                spawn_media(
                    script_path .. "backlight -l -d 1%",
                    "screen_backlight_change"
                )
            end
        end,
    }),
    awful.button({
        button = 4,
        on_press = function()
            if not is_builtin_output() then
                spawn_media(
                    script_path .. "backlight -m -i 5%",
                    "screen_backlight_change"
                )
            else
                spawn_media(
                    script_path .. "backlight -l -i 1%",
                    "screen_backlight_change"
                )
            end
        end,
    }),
    awful.button({
        button = 3,
        on_press = function()
            if not is_builtin_output() then
                spawn_media(
                    script_path .. "backlight -b -i 5%",
                    "screen_bluelight_change"
                )
            else -- Laptop blue light
                update_bluelevel_laptop(5)
            end
        end,
    }),
    awful.button({
        button = 2,
        on_press = function()
            awful.spawn(script_path .. "color")
        end,
    }),
    awful.button({
        button = 1,
        on_press = function()
            if not is_builtin_output() then
                spawn_media(
                    script_path .. "backlight -b -d 5%",
                    "screen_bluelight_change"
                )
            else -- Laptop blue light
                update_bluelevel_laptop(-5)
            end
        end,
    }),
}

local brightness_icon = helpers.svg({
    theme_var = "bar_fg",
    buttons = brightness_buttons,
    update_hook = function(self, theme)
        local tail = theme == "light" and ".svg" or "-night.svg"
        self.icon = beautiful.icon_path .. "backlight/screen" .. tail
    end,
})
local brightness = wibox.widget({
    brightness_icon,
    top = beautiful.icon_v_padding,
    bottom = beautiful.icon_v_padding,
    layout = wibox.container.margin,
})

return brightness

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
