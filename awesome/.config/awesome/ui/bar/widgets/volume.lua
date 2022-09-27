local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("ui.helpers")

local volume_buttons = {
    awful.button({
        button = 1,
        on_press = function()
            awful.spawn(script_path .. "volume -t")
        end,
    }),
    awful.button({
        button = 4,
        on_press = function()
            awful.spawn(script_path .. "volume -d 5")
        end,
    }),
    awful.button({
        button = 5,
        on_press = function()
            awful.spawn(script_path .. "volume -i 5")
        end,
    }),
}

local volume_icon = helpers.svg({
    icon = beautiful.icon_path .. "volume/volume-low.svg",
    theme_var = "bar_fg",
    buttons = volume_buttons,
})
volume_icon.level = 0
volume_icon.muted = true

helpers.tooltip(volume_icon, function()
    local muted = volume_icon.muted and " (muted)" or ""
    return "Volume at " .. tostring(volume_icon.level) .. "%" .. muted
end)

function volume_icon:update_volume(level, muted)
    if level == nil then
        return -- bad initialization
    end

    -- tooltip infos
    volume_icon.level = level
    volume_icon.muted = muted

    if muted then
        volume_icon:update(nil, beautiful.icon_path .. "/volume/volume-off.svg")
    elseif level < 10 then
        volume_icon:update(nil, beautiful.icon_path .. "/volume/volume-low.svg")
    elseif level < 60 then
        volume_icon:update(
            nil,
            beautiful.icon_path .. "/volume/volume-medium.svg"
        )
    else
        volume_icon:update(
            nil,
            beautiful.icon_path .. "/volume/volume-high.svg"
        )
    end
end

local volume = {
    volume_icon,
    top = beautiful.icon_v_padding,
    bottom = beautiful.icon_v_padding,
    layout = wibox.container.margin,
}

awesome.connect_signal("volume_change", function(level, muted)
    volume_icon:update_volume(level, muted)
end)

return volume

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
