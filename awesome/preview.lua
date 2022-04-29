local beautiful = require("beautiful")
local wibox     = require("wibox")
local awful     = require("awful")
local gears     = require("gears")
local helpers   = require("helpers")
local dpi       = beautiful.xresources.apply_dpi
local screen    = screen.primary
local cairo     = require("lgi").cairo

-- Preview of a client a one scale
local function preview(c, scale)
    local content
    if c.first_tag.selected then
        content = gears.surface(c.content)
    else
        content = gears.surface(c.old_content)
    end
    local img = cairo.ImageSurface.create(
                    cairo.Format.ARGB32, c.width, c.height)
    cr = cairo.Context(img)
    cr:set_source_surface(content)
    cr:paint()

    return wibox.widget {
        image = gears.surface.load(img),
        resize = true,
        forced_height = math.floor(c.height * scale),
        forced_width  = math.floor(c.width * scale),
        widget = wibox.widget.imagebox
    }
end

-- The popup itself
local popup = wibox {
    screen  = screen,
    x       = dpi(10),
    y       = beautiful.wibar_height + dpi(10),
    bg      = "#00000000", -- for anti-aliasing
    type    = "tooltip",
    visible = false,
    ontop   = true,
}

-- Support drag
--  popup:buttons(gears.table.join(
--    awful.button({}, 1, function() awful.mouse.wibox.move(popup) end)))

local inner_widget = wibox.layout.manual()
local scale = 0.2

function popup:update(tag)
    -- Update the widget
    inner_widget:reset()
    -- Clean up
    collectgarbage("collect")
    -- Screen size
    local fallback_padding = {
        left   = 0,
        right  = 0,
        top    = 0,
        bottom = 0
    }
    tag.padding = tag.padding or fallback_padding
    local geo = tag.screen:get_bounding_geometry {
        honor_padding  = false,
        honor_workarea = false
    }
    -- Update the preview size
    popup:geometry {
        width  = geo.width*scale,
        height = geo.height*scale,
    }
    -- Create the preview
    local clients = tag:clients()
    for i = 1, #clients do
        local c = clients[i]
        local prev = preview(c, scale)
        -- Position of the widget
        prev.point = {
            x = math.floor((c.x - geo.x)*scale),
            y = math.floor((c.y - geo.y)*scale),
        }
        -- Add it to the preview
        inner_widget:add(prev)
    end
end

-- Show on a given screen
function popup:show(screen, do_show)
   -- show on the correct screen
    local geometry = screen.geometry
    popup:geometry {
        x = geometry.x + dpi(10),
        y = geometry.y + dpi(10) + beautiful.wibar_height
    }
    -- show the popup widget
    popup.visible = do_show
end

-- Show the preview with a signal
awesome.connect_signal("preview_show", function(screen, do_show)
    popup:show(screen, do_show)
end)

-- Update the preview for a given tag
awesome.connect_signal("preview_update", function(tag)
    popup:update(tag)
end)

-- {{{ Updates
tag.connect_signal("property::selected", function(tag)
    helpers.delay(function()
        if tag.selected then
            local clients = tag:clients()
            for i = 1, #clients do
                local c = clients[i]
                c.old_content = gears.surface.duplicate_surface(c.content)
            end
        end
    end)
end)

client.connect_signal("focus", function(c)
    helpers.delay(function()
        c.old_content = gears.surface.duplicate_surface(c.content)
    end)
end)
-- }}}

-- {{{ Wallpaper of the preview
local bg_widget = wibox.widget {
    image = beautiful.wallpaper,
    horizontal_fit_policy = "fit",
    vertical_fit_policy   = "fit",
    widget = wibox.widget.imagebox
}

-- Update bg image when theme changes
awesome.connect_signal("theme_change", function(_)
    bg_widget.image = gears.surface.load_uncached(beautiful.wallpaper)
end)
-- }}}

-- Add anti-aliased rounded corners and borders
popup:setup {
    {
        bg_widget,
        inner_widget,
        layout = wibox.layout.stack
    },
    shape  = gears.shape.rounded_rect,
    widget = wibox.container.background,
    border_width = beautiful.border_width,
    border_color = beautiful.border_normal
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
