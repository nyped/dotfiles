local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = {}

-- Partially rounded rectangle
function helpers.prrect(tl, tr, br, bl)
    return function(cr, w, h, rad)
        return gears.shape.partially_rounded_rect(cr, w, h, tl, tr, br, bl, rad)
    end
end

-- Sizer
function helpers.constraint(widget, height, width, strategy)
    strategy = strategy or "min"
    return wibox.widget({
        widget,
        strategy = strategy,
        width = width,
        height = height,
        widget = wibox.container.constraint,
    })
end

-- {{{ Svg icon

-- params: icon, height, width, theme_var, buttons, update_hook
function helpers.svg(params)
    local ret = wibox.widget({
        forced_height = params.height,
        forced_width = params.width,
        update_hook = params.update_hook,
        buttons = params.buttons,
        icon = params.icon,
        widget = wibox.widget.imagebox,
    })

    -- New icon or recolor method
    function ret:update(theme, icon)
        if ret.update_hook then
            ret:update_hook(theme, icon)
        end
        icon = icon or ret.icon
        theme = theme or theme_name
        ret.stylesheet = "*{fill:"
            .. beautiful.theme[theme][params.theme_var or "fg"]
            .. ";}"
        ret.icon = icon
        ret.image = icon
    end

    -- Init
    ret:update(theme_name, params.icon)
    awesome.connect_signal("theme_change", function(theme)
        ret:update(theme)
    end)

    return ret
end
-- }}}

-- {{{ Tooltip
function helpers.tooltip(widget, func, theme_fg, theme_bg)
    local ret = awful.tooltip({
        objects = { widget },
        timer_function = func,
    })
    ret.theme_bg = theme_bg or "bg"
    ret.theme_fg = theme_fg or "fg"

    -- Theme sync
    function ret:on_theme_change(theme)
        ret.widget.fg = beautiful.theme[theme][ret.theme_fg]
        ret.widget.bg = beautiful.theme[theme][ret.theme_bg]
    end

    awesome.connect_signal("theme_change", function(theme)
        ret:on_theme_change(theme)
    end)

    -- Init
    ret:on_theme_change(theme_name)

    return ret
end
-- }}}

-- Change the background according to the theme {{{
function helpers.themed(
    widget,
    bg_name,
    fg_name,
    shape,
    border_width,
    hover_name
)
    local ret = wibox.container.background(widget)

    -- default value if not given
    ret.shape = shape or nil
    ret.bg_name = bg_name or nil
    ret.fg_name = fg_name or nil
    ret.hover_name = hover_name or nil
    ret.border_width = border_width or nil
    ret.border_color = beautiful.border_normal

    -- State of the widget
    ret.focused = false
    ret.theme = theme_name
    ret.widget = widget

    function ret:on_theme_change(theme)
        if theme == nil then
            return
        end
        ret.theme = theme
        if ret.bg_name ~= nil then
            ret.bg = beautiful.theme[theme][ret.bg_name]
        end
        if ret.fg_name ~= nil and not ret.focused then
            ret.fg = beautiful.theme[theme][ret.fg_name]
        end
    end

    -- initialisation
    ret:on_theme_change(theme_name)

    -- Setting hover
    if hover_name ~= nil then
        ret:connect_signal("mouse::enter", function()
            ret.focused = true
            ret.fg = beautiful.theme[ret.theme][ret.hover_name]
        end)

        ret:connect_signal("mouse::leave", function()
            ret.focused = false
            ret.fg = beautiful.theme[ret.theme][ret.fg_name]
        end)
    end

    -- Changing the theme
    awesome.connect_signal("theme_change", function(t)
        ret:on_theme_change(t)
    end)

    return ret
end
-- }}}

-- {{{ Container connected to theme_change signal
function helpers.custom_container_bg(bg_name, fg_name, constructor)
    local function create_instance()
        local ret = wibox.container.background()
        bg_name = bg_name or nil
        fg_name = fg_name or nil

        -- initialisation and connection
        if bg_name ~= nil then
            ret.bg = beautiful.theme[theme_name][bg_name]
            awesome.connect_signal("theme_change", function(theme)
                ret.bg = beautiful.theme[theme][bg_name]
            end)
        end
        if fg_name ~= nil then
            ret.fg = beautiful.theme[theme_name][fg_name]
            awesome.connect_signal("theme_change", function(theme)
                ret.fg = beautiful.theme[theme][fg_name]
            end)
        end

        return ret
    end

    if constructor == nil then -- return an instance
        return create_instance()
    end
    return create_instance -- return a constructor
end
-- }}}

-- Pango formatted time
function helpers.markup_format(format, font, size)
    format = format or "" -- bruh should not happen
    size = size or 20
    font = font or beautiful.font

    return '<span size="'
        .. tostring(size)
        .. 'pt"'
        .. ' font="'
        .. font
        .. '" '
        .. ">"
        .. format
        .. "</span>"
end

-- Center a widget
function helpers.centered(widget)
    return {
        nil,
        {
            nil,
            widget,
            nil,
            expand = "outside",
            layout = wibox.layout.align.horizontal,
        },
        nil,
        expand = "outside",
        layout = wibox.layout.align.vertical,
    }
end

-- Pad a widget
function helpers.padded(widget, top, bottom, left, right)
    top = top or dpi(10)
    bottom = bottom or dpi(10)
    left = left or dpi(10)
    right = right or dpi(10)

    return wibox.container.margin(widget, left, right, top, bottom)
end

-- Pad with the same padding
function helpers.equal_padded(widget, pad)
    return helpers.padded(widget, pad, pad, pad, pad)
end

-- What to say hyn
function helpers.spawner(cmd)
    return function()
        awful.spawn(cmd)
    end
end

-- Create a button
function helpers.create_button(symbol, left_func, right_func, font_size)
    font_size = font_size or 15
    local icon = wibox.widget({
        markup = helpers.markup_format(symbol, beautiful.icon_font, font_size),
        align = "center",
        valign = "center",
        font_size = font_size,
        widget = wibox.widget.textbox,
    })

    local button_widget = wibox.widget({
        icon,
        buttons = {
            awful.button({}, 1, nil, left_func),
            awful.button({}, 3, nil, right_func),
        },
        widget = wibox.container.background,
    })

    local ret = helpers.themed(button_widget, nil, "fg", nil, nil, "hover")
    ret.icon = icon -- We want to be able to change the icon

    return ret
end

-- Button widget
function helpers.create_button_widget(symbol, left_func, right_func, font_size)
    local inner_button =
        helpers.create_button(symbol, left_func, right_func, font_size)

    local ret = helpers.themed(
        helpers.equal_padded(inner_button, dpi(20)),
        "bg",
        nil,
        gears.shape.rounded_rect,
        beautiful.border_width
    )

    -- We want to be able to change the icon
    ret.icon = inner_button.icon

    return ret
end

-- {{{ delay a call
function helpers.delay(func, timeout)
    timeout = timeout or 0.1
    gears.timer({
        timeout = timeout,
        call_now = false,
        autostart = true,
        single_shot = true,
        callback = function()
            func()
        end,
    })
end
-- }}}

return helpers

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
