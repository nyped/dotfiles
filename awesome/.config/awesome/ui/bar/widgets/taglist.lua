local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")
local wibox = require("wibox")

-- luacheck: push ignore index tags
local update_tag = function(widget, tag, index, tags)
    local icon = widget:get_children_by_id("svg_role")[1]
    local underline = widget:get_children_by_id("underline_role")[1]
    local overline = widget:get_children_by_id("overline_role")[1]
    local icon_col = "bar_fg"
    local overline_col = "bar_bg"
    local underline_col = "bar_bg"

    if tag.urgent then
        icon_col = "hover"
        underline_col = "hover"
    end

    if tag.selected then
        underline_col = "bar_fg"
    end

    if tag.pinned then
        overline_col = "bar_fg"
    end

    icon:recolor(icon_col)
    overline:recolor(overline_col)
    underline:recolor(underline_col)
end -- luacheck: pop

local init_tag = function(widget, tag, index, tags)
    local icon = widget:get_children_by_id("svg_role")[1]
    local underline = widget:get_children_by_id("underline_role")[1]
    local overline = widget:get_children_by_id("overline_role")[1]

    -- Appending update methods
    function icon:recolor(color)
        icon.stylesheet = "*{fill:"
            .. beautiful.theme[theme_name][color]
            .. ";}"
    end
    function underline:recolor(color)
        underline.bg = beautiful.theme[theme_name][color]
    end
    function overline:recolor(color)
        overline.bg = beautiful.theme[theme_name][color]
    end
    tag.update = function()
        update_tag(widget, tag, index, tags)
    end

    -- Hover/Themes
    widget:connect_signal("mouse::enter", function()
        icon:recolor("hover")
    end)
    widget:connect_signal("mouse::leave", tag.update)
    awesome.connect_signal("theme_change", tag.update)

    -- Init
    icon.image = beautiful.icon_path .. "taglist/" .. tag.name .. ".svg"
    tag.update()
end

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({}, 3, awful.tag.viewtoggle)
)

return function(s)
    return awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.noempty,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    {
                        id = "svg_role",
                        widget = wibox.widget.imagebox,
                    },
                    left = beautiful.icon_h_padding,
                    right = beautiful.icon_h_padding,
                    top = beautiful.icon_v_padding,
                    bottom = beautiful.icon_v_padding,
                    widget = wibox.container.margin,
                },
                {
                    id = "text_role",
                    text = "test",
                    visible = false,
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.align.horizontal,
            },
            {
                {
                    wibox.widget.base.make_widget(),
                    id = "underline_role",
                    shape = gears.shape.rounded_rect,
                    widget = wibox.container.background,
                },
                top = dpi(22),
                left = dpi(1),
                right = dpi(1),
                widget = wibox.container.margin,
            },
            {
                {
                    nil,
                    {
                        wibox.widget.base.make_widget(),
                        id = "overline_role",
                        forced_width = dpi(7.5),
                        shape = gears.shape.rounded_rect,
                        widget = wibox.container.background,
                    },
                    nil,
                    expand = "outside",
                    layout = wibox.layout.align.horizontal,
                },
                bottom = dpi(22),
                widget = wibox.container.margin,
            },
            layout = wibox.layout.stack,
            create_callback = init_tag,
            update_callback = update_tag,
        },
    })
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
