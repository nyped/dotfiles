local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("ui.helpers")

-- luacheck: push ignore i o
local init_task = function(widget, c, i, o)
    local instance = c.class or "None"
    local name = c.name or "None"
    instance = instance:gsub("[oO]rg.gnome.", "")
    instance = instance:gsub("^%l", string.upper)
    -- Add a tooltip
    widget.tooltip = helpers.tooltip(widget, function()
        return instance .. " - " .. name
    end)
    -- Updating the text
    widget:get_children_by_id("custom_text_role")[1].text = instance
end -- luacheck: pop

return function(s)
    return awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.minimizedcurrenttags,
        buttons = gears.table.join(awful.button({}, 1, function(c)
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end)),
        layout = {
            spacing = dpi(20),
            layout = wibox.layout.fixed.horizontal,
        },
        widget_template = {
            {
                {
                    {
                        id = "icon_role",
                        widget = wibox.widget.imagebox,
                    },
                    left = beautiful.icon_h_padding / 2,
                    right = beautiful.icon_h_padding,
                    top = dpi(4),
                    bottom = dpi(4),
                    widget = wibox.container.margin,
                },
                {
                    id = "custom_text_role",
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            widget = helpers.custom_container_bg("bar_bg", "bar_fg", true),
            create_callback = init_task,
        },
    })
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
