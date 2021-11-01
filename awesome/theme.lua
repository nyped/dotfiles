---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font          = "sans 8"

theme.bg_normal     = "#00000000"
theme.bg_focus      = "#00000017"
theme.bg_urgent     = "#00000000"
theme.bg_minimize   = "#00000000"

theme.fg_normal     = "#223238"
theme.fg_focus      = "#000000"
theme.fg_urgent     = "#e53935"
theme.fg_minimize   = "#000000"

theme.hotkeys_fg     = "#223238"
theme.hotkeys_bg     = "#e4e4e4"

theme.tooltip_fg     = "#223238"
theme.tooltip_bg     = "#e4e4e4"
theme.tooltip_border_color = "#b3b3b3"
theme.tooltip_border_width = 1

theme.progressbar_bg = "#e4e4e4"
theme.progressbar_fg = "#808080"
theme.progressbar_border_color = "#808080"
theme.progressbar_border_width = 1

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

theme.titlebar_fg = theme.fg_normal
theme.titlebar_bg = "#f2f2f2"
theme.titlebar_fg_focus = theme.fg_normal
theme.titlebar_bg_focus = "#e4e4e4"
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_bg_normal = "#e4e4e4"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_fg = "#223238"
theme.menu_bg = "#e4e4e4"
theme.menu_fg_normal = "#223238"
theme.menu_bg_normal = "#e4e4e4"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"


-- titlebar stuff

local gears = require("gears")
local circle = function(cr, width, height)
    gears.shape.circle(cr, width, height, width/4)
end

theme.titlebar_button_size = 20
theme.color_idle_normal = "#98989d"
theme.color_idle_focus = "#848489"

theme.titlebar_close_focus = "#ff443a"
theme.titlebar_close_normal = theme.color_idle_normal
theme.titlebar_maximized_focus_inactive = "#6ac4dc"
theme.titlebar_maximized_normal_inactive = theme.color_idle_normal
theme.titlebar_maximized_focus_active = "#6ac4dc"
theme.titlebar_maximized_normal_active = theme.color_idle_normal
theme.titlebar_sticky_focus_inactive = theme.color_idle_focus
theme.titlebar_sticky_normal_inactive = theme.color_idle_normal
theme.titlebar_sticky_focus_active = "#ff9d0a"
theme.titlebar_sticky_normal_active = "#ff9d0a"
theme.titlebar_floating_focus_inactive = "#0a84ff"
theme.titlebar_floating_normal_inactive = theme.color_idle_normal
theme.titlebar_floating_focus_active = "#0a84ff"
theme.titlebar_floating_normal_active = theme.color_idle_normal

-- Define the image to load
--theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_normal = gears.surface.load_from_shape(
                                        theme.titlebar_button_size,
                                        theme.titlebar_button_size,
                                        circle,
                                        theme.titlebar_close_normal
                                    )
theme.titlebar_close_button_focus = gears.surface.load_from_shape(
                                        theme.titlebar_button_size,
                                        theme.titlebar_button_size,
                                        circle,
                                        theme.titlebar_close_focus
                                    )
theme.titlebar_sticky_button_focus_inactive = gears.surface.load_from_shape(
                                        theme.titlebar_button_size,
                                        theme.titlebar_button_size,
                                        circle,
                                        theme.titlebar_sticky_focus_inactive
                                    )
theme.titlebar_sticky_button_normal_inactive = gears.surface.load_from_shape(
                                        theme.titlebar_button_size,
                                        theme.titlebar_button_size,
                                        circle,
                                        theme.titlebar_sticky_normal_inactive
                                    )
theme.titlebar_sticky_button_focus_active = gears.surface.load_from_shape(
                                        theme.titlebar_button_size,
                                        theme.titlebar_button_size,
                                        circle,
                                        theme.titlebar_sticky_focus_active
                                    )
theme.titlebar_sticky_button_normal_active = gears.surface.load_from_shape(
                                        theme.titlebar_button_size,
                                        theme.titlebar_button_size,
                                        circle,
                                        theme.titlebar_sticky_normal_active
                                    )
theme.titlebar_maximized_button_focus_inactive = gears.surface.load_from_shape(
                                        theme.titlebar_button_size,
                                        theme.titlebar_button_size,
                                        circle,
                                        theme.titlebar_maximized_focus_inactive
                                    )
theme.titlebar_maximized_button_normal_inactive = gears.surface.load_from_shape(
                                        theme.titlebar_button_size,
                                        theme.titlebar_button_size,
                                        circle,
                                        theme.titlebar_maximized_normal_inactive
                                    )
theme.titlebar_maximized_button_focus_active = gears.surface.load_from_shape(
                                        theme.titlebar_button_size,
                                        theme.titlebar_button_size,
                                        circle,
                                        theme.titlebar_maximized_focus_active
                                    )
theme.titlebar_maximized_button_normal_active = gears.surface.load_from_shape(
                                        theme.titlebar_button_size,
                                        theme.titlebar_button_size,
                                        circle,
                                        theme.titlebar_maximized_normal_active
                                    )
theme.titlebar_floating_button_focus_inactive = gears.surface.load_from_shape(
                                        theme.titlebar_button_size,
                                        theme.titlebar_button_size,
                                        circle,
                                        theme.titlebar_floating_focus_inactive
                                    )
theme.titlebar_floating_button_normal_inactive = gears.surface.load_from_shape(
                                        theme.titlebar_button_size,
                                        theme.titlebar_button_size,
                                        circle,
                                        theme.titlebar_floating_normal_inactive
                                    )
theme.titlebar_floating_button_focus_active = gears.surface.load_from_shape(
                                        theme.titlebar_button_size,
                                        theme.titlebar_button_size,
                                        circle,
                                        theme.titlebar_floating_focus_active
                                    )
theme.titlebar_floating_button_normal_active = gears.surface.load_from_shape(
                                        theme.titlebar_button_size,
                                        theme.titlebar_button_size,
                                        circle,
                                        theme.titlebar_floating_normal_active
                                    )

theme.wallpaper = "/home/lenny/Pictures/wallpaper.png"

local layout_path = "/home/lenny/.config/awesome/layouts/"

-- default awful related
-- https://epsi-rns.github.io/desktop/2019/10/22/awesome-theme-layout.html
theme.layout_dwindle        = layout_path .. "dwindle.png"
theme.layout_fairh          = layout_path .. "fairh.png"
theme.layout_fairv          = layout_path .. "fairv.png"
theme.layout_floating       = layout_path .. "floating.png"
theme.layout_magnifier      = layout_path .. "magnifier.png"
theme.layout_max            = layout_path .. "max.png"
theme.layout_spiral         = layout_path .. "spiral.png"
theme.layout_tilebottom     = layout_path .. "tilebottom.png"
theme.layout_tileleft       = layout_path .. "tileleft.png"
theme.layout_tile           = layout_path .. "tile.png"
theme.layout_tiletop        = layout_path .. "tiletop.png"

theme.layout_fullscreen     = layout_path .. "fullscreen.png"
theme.layout_cornernw       = layout_path .. "cornernw.png"
theme.layout_cornerne       = layout_path .. "cornerne.png"
theme.layout_cornersw       = layout_path .. "cornersw.png"
theme.layout_cornerse       = layout_path .. "cornerse.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_normal, theme.fg_normal
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
