local awful = require("awful")
local wibox = require("wibox")
local helpers = require("ui.helpers")

local class = wibox.widget({
    widget = wibox.widget.textbox,
    buttons = {
        awful.button({
            button = 1,
            on_press = function()
                awesome.emit_signal("control_center::toggle")
            end,
        }),
    },
})

client.connect_signal("unfocus", function()
    class.visible = false
end)

client.connect_signal("focus", function(c)
    local name = "No name"
    -- bruh, gnome apps
    if c.class then
        name = c.class:gsub("[oO]rg.gnome.", "")
    end
    name = name:gsub("^%l", string.upper)
    class:set_markup_silently(name)
    class.visible = true
    class.client = c
end)

helpers.tooltip(class, function()
    local c = class.client
    if c == nil then
        return
    end
    local tail = c.name and " - " .. c.name or ""
    return c.class .. tail
end)

return class

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
