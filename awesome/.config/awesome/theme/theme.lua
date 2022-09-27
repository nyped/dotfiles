local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font_family = "JetBrains Mono Regular"
theme.font = theme.font_family .. " 8"
theme.icon_font = "Symbols Nerd Font"

-- wibar stuff
theme.icon_h_padding = dpi(10)
theme.icon_v_padding = dpi(5)
theme.wibar_border_width = 0
theme.wibar_height = dpi(25)
theme.wibar_item_spacing = dpi(25)
theme.wibar_padding = dpi(20)

theme.transparent = "#00000000"

-- systray
theme.systray_icon_spacing = theme.wibar_item_spacing

-- time widget
theme.hour_widget_fg = "#c83349"
theme.minute_widget_fg = "#5b9aa0"
theme.second_widget_fg = "#622569"
theme.meridiem_widget_fg = "#f2ae72"

-- calendar widget
theme.day_name_widget_fg = "#8b6f47"
theme.day_number_widget_fg = "#c94c4c"
theme.month_name_widget_fg = "#485f6a"

-- weather widget
theme.weather_temperature_fg = "#c1502e"
theme.weather_text_fg = "#bd5734"

-- buttons and default
theme.button_hover_fg = "#c94c4c"

theme.bg_normal = "#00000000"
theme.bg_focus = "#00000018"
theme.bg_urgent = "#00000000"
theme.bg_minimize = "#00000000"

theme.fg_normal = "#000000"
theme.fg_focus = "#000000"
theme.fg_urgent = "#e53935"
theme.fg_minimize = "#000000"

theme.hotkeys_fg = "#223238"
theme.hotkeys_bg = "#e4e4e4"

theme.tooltip_fg = "#223238"
theme.tooltip_bg = "#e4e4e4"
theme.tooltip_border_color = "#b3b3b3"
theme.tooltip_border_width = 1

theme.progressbar_bg = "#e4e4e4"
theme.progressbar_fg = theme.fg_normal
theme.progressbar_border_color = "#808080"
theme.progressbar_border_width = 1

theme.gap_single_client = true
theme.useless_gap = 10

theme.border_width = dpi(1)
theme.border_normal = "#b3b3b3"
theme.border_focus = "#b3b3b3"
theme.border_marked = "#e53935"

theme.titlebar_size = dpi(20)
theme.titlebar_fg = theme.fg_normal
theme.titlebar_bg = "#00000000"
theme.titlebar_fg_focus = theme.fg_normal
theme.titlebar_bg_focus = "#e4e4e4"
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_bg_normal = "#e4e4e4"

theme.icon_path = "/home/lenny/.config/awesome/theme/assets/"

theme.theme = {
    light = {
        bg = "#e0e2e4ee",
        fg = "#3e515b",
        bg_alt = "#c8ccd0cc",
        hour = "#c83349",
        minute = "#5b9aa0",
        second = "#622569",
        meridiem = "#f2ae72",
        day_number = "#c94c4c",
        weather_cond = "#bd5734",
        weather_temp = "#c1502e",
        meridian = "#f2ae72",
        day_name = "#8b6f47",
        month_name = "#485f6a",
        hover = "#c94c4c",
        progressbar_bg = "#e0e2e4",
        progressbar_fg = "#3e515b",
        bar_bg = "#e0e2e4",
        bar_fg = "#263238",
    },
    dark = {
        bg = "#282b30ee",
        fg = "#e3e6e8",
        bg_alt = "#282b30aa",
        hour = "#eca1a6",
        minute = "#b5e7a0",
        second = "#fefbd8",
        meridiem = "#b2c2bf",
        day_number = "#c94c4c",
        weather_cond = "#dac292",
        weather_temp = "#f18973",
        meridian = "#b2c2bf",
        day_name = "#fefbd8",
        month_name = "#eceff1",
        hover = "#c94c4c",
        progressbar_bg = "#282b30",
        progressbar_fg = "#e3e6e8",
        bar_bg = "#282b30",
        bar_fg = "#e3e6e8",
    },
}

theme.snap_shape = gears.shape.rectangle
theme.snap_border_width = 1

-- Variables set for theming notifications:
theme.notification_margin = dpi(10)
theme.notification_font = theme.font
theme.notification_border_width = 0
theme.notification_border_color = theme.border_normal
theme.notification_icon_size = dpi(100)
theme.notification_icon_resize_strategy = "center"

-- Variables set for theming the menu
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_fg = "#223238"
theme.menu_bg = "#e4e4e4"
theme.menu_fg_normal = "#223238"
theme.menu_bg_normal = "#e4e4e4"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

-- titlebar stuff
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

theme.overline_color = "#808080"

theme.wallpaper = "/home/lenny/Pictures/wallpaper.png"

local layout_path = "/home/lenny/.config/awesome/theme/assets/layouts/"

-- {{{ Calendar stuff
theme.calendar_year_bg_color = "#e4e4e4"
theme.calendar_month_bg_color = "#e4e4e4"
theme.calendar_yearheader_bg_color = "#e4e4e4"
theme.calendar_header_bg_color = "#e4e4e4"
theme.calendar_weekday_bg_color = "#e4e4e4"
theme.calendar_normal_bg_color = "#e4e4e4"
theme.calendar_focus_bg_color = "#808080"

theme.calendar_year_border_width = 1
theme.calendar_month_border_width = 1
theme.calendar_yearheader_border_width = 1
theme.calendar_header_border_width = 1
theme.calendar_weekday_border_width = 1
theme.calendar_normal_border_width = 1
theme.calendar_focus_border_width = 1

theme.calendar_year_border_color = "#b3b3b3"
theme.calendar_month_border_color = "#b3b3b3"
theme.calendar_yearheader_border_color = "#e4e4e4"
theme.calendar_header_border_color = "#e4e4e4"
theme.calendar_weekday_border_color = "#e4e4e4"
theme.calendar_normal_border_color = "#e4e4e4"
theme.calendar_focus_border_color = "#b3b3b3"

theme.calendar_focus_markup = "<b>%s</b>"
theme.calendar_focus_fg_color = "#e4e4e4"

theme.calendar_yearheader_shape = gears.shape.rounded_bar
theme.calendar_header_shape = gears.shape.rounded_bar
theme.calendar_weekday_shape = gears.shape.rounded_bar
theme.calendar_normal_shape = gears.shape.rounded_bar
theme.calendar_focus_shape = gears.shape.rect

theme.calendar_year_padding = dpi(10)
theme.calendar_month_padding = dpi(10)
-- }}}

-- default awful related
-- https://epsi-rns.github.io/desktop/2019/10/22/awesome-theme-layout.html
theme.layout_dwindle = layout_path .. "dwindle.png"
theme.layout_fairh = layout_path .. "fairh.png"
theme.layout_fairv = layout_path .. "fairv.png"
theme.layout_floating = layout_path .. "floating.png"
theme.layout_magnifier = layout_path .. "magnifier.png"
theme.layout_max = layout_path .. "max.png"
theme.layout_spiral = layout_path .. "spiral.png"
theme.layout_tilebottom = layout_path .. "tilebottom.png"
theme.layout_tileleft = layout_path .. "tileleft.png"
theme.layout_tile = layout_path .. "tile.png"
theme.layout_tiletop = layout_path .. "tiletop.png"

theme.layout_fullscreen = layout_path .. "fullscreen.png"
theme.layout_cornernw = layout_path .. "cornernw.png"
theme.layout_cornerne = layout_path .. "cornerne.png"
theme.layout_cornersw = layout_path .. "cornersw.png"
theme.layout_cornerse = layout_path .. "cornerse.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height,
    theme.bg_normal,
    theme.fg_normal
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80