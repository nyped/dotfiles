local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local beautiful = require("beautiful")

-- WMCLASS widget
-- {{{
local class = wibox.widget.textbox()

-- open menu when clicked
class.buttons = {
    awful.button {
        button = 1,
        on_press = function ()
            awful.util.spawn("/home/lenny/dotfiles/scripts/menu")
        end
    }
}

client.connect_signal("unfocus", function (c)
    class:set_markup_silently("")
end)

client.connect_signal("focus", function (c)
    name = c.class == nil and "" or c.class:gsub("^%l", string.upper)
    class:set_markup_silently(name)
end)

local window_class = {
    class,
    left = dpi(20),
    layout = wibox.layout.margin
}
-- }}}

-- {{{ Battery widget
local bat = wibox.widget {
    {
        id = "wrap",
        {
            id = "logo",
            current_icon = 10,
            image  = gears.surface.load_uncached(beautiful.icon_path.."battery/battery-10.png"),
            resize = true,
            widget = wibox.widget.imagebox
        },
        right   = dpi(5),
        top    = dpi(7),
        bottom = dpi(7),
        layout = wibox.container.margin
    },
    {
        id = "percentage",
        markup = '50<b>%</b>',
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
    update_meta = function(self, charging, capacity_str)
        local capacity = tonumber(capacity_str), image

        self.percentage:set_markup_silently(capacity_str.."%")

        if capacity == 100 then
            image = beautiful.icon_path.."battery/battery-100.png"
            self.percentage:set_markup_silently("")
        elseif charging then
            image = beautiful.icon_path.."battery/battery-charging-"..tostring(self.wrap.logo.current_icon)..".png"
            self.wrap.logo.current_icon = ((self.wrap.logo.current_icon + 10) > 100) and 10 or (self.wrap.logo.current_icon + 10)
        else
            image = beautiful.icon_path.."battery/battery-"..tostring(math.ceil(capacity/10)*10)..".png"
        end

        self.wrap.logo:set_image(image)
    end
}

local battery = awful.widget.watch(
    'cat /sys/class/power_supply/BAT0/capacity '
    ..'/sys/class/power_supply/BAT0/status',
    1,
    function(widget, stdout)
        local capacity_str, status, charging

        capacity_str = stdout:match("(%d+)")
        status       = stdout:match("([a-zA-Z]+)")
        charging     = status == "Charging" and true or false
        widget:update_meta(charging, capacity_str)
    end,
    bat
)
-- }}}

-- {{{ Volume widget
local volume_icon = wibox.widget {
    image = beautiful.icon_path.."volume/volume-low.png",
    widget = wibox.widget.imagebox,
    buttons = {
        awful.button {
            button = 1,
            on_press = function ()
                awful.util.spawn("/home/lenny/dotfiles/scripts/volume -t")
            end
        },
        awful.button {
            button = 4,
            on_press = function ()
                awful.util.spawn("/home/lenny/dotfiles/scripts/volume -d 5")
            end
        },
        awful.button {
            button = 5,
            on_press = function ()
                awful.util.spawn("/home/lenny/dotfiles/scripts/volume -i 5")
            end
        }
    },
    update_volume = function(self, volume_level, muted)
        if muted then
            if volume_level < 20 then
                self:set_image(beautiful.icon_path.."/volume/volume-variant-off.png")
            else
                self:set_image(beautiful.icon_path.."/volume/volume-off.png")
            end
        elseif volume_level < 10 then
            self:set_image(beautiful.icon_path.."/volume/volume-low.png")
        elseif volume_level < 60 then
            self:set_image(beautiful.icon_path.."/volume/volume-medium.png")
        else
            self:set_image(beautiful.icon_path.."/volume/volume-high.png")
        end
    end
}

local volume = {
    volume_icon,
    top    = dpi(7),
    bottom = dpi(7),
    layout = wibox.container.margin
}

awesome.connect_signal("volume_change",
    function (volume_level, muted)
        volume_icon:update_volume(volume_level, muted)
    end
)
-- }}}

-- {{{ Brightness widget
local brightness_icon = awful.widget.button {
    day     = true,
    image   = beautiful.icon_path.."backlight/screen.png",
    buttons = {
        awful.button {
            button = 4,
            on_press = function()
                update_backlight(
                    "/home/lenny/dotfiles/scripts/backlight -l -d 1%",
                    "screen_backlight_change")
            end
        },
        awful.button {
            button = 5,
            on_press = function()
                update_backlight(
                    "/home/lenny/dotfiles/scripts/backlight -l -i 1%",
                    "screen_backlight_change")
            end
        }
    }
}

local function update_temperature()
    local cmd, tail
    if brightness_icon.day then
        cmd   = "redshift -m randr:crtc=0 -P -O 6500"
        tail  = "backlight/screen.png"
        state = "night"
    else
        cmd   = "redshift -m randr:crtc=0 -P -O 4500"
        tail  = "backlight/screen-night.png"
        state = "day"
    end
    awful.util.spawn(cmd)
    brightness_icon:set_image(beautiful.icon_path..tail)
    brightness_icon.day = not(brightness_icon.day)
    awesome.emit_signal("temperature_change", state)
end

brightness_icon:add_button(
    awful.button {
        button = 1,
        on_press = function()
            update_temperature()
            update_backlight(
                "/home/lenny/dotfiles/scripts/backlight -l -i 0%",
                "screen_backlight_change"
            )
        end
    }
)

local brightness = {
    brightness_icon,
    top    = dpi(7),
    bottom = dpi(7),
    layout = wibox.container.margin
}
-- }}}

-- {{{ hwmon
local hwmon_buttons = {
    awful.button {
        button = 1,
        on_press = function ()
            awful.util.spawn("/home/lenny/dotfiles/scripts/fan_menu")
        end
    }
}

local temperature = awful.widget.watch(
    'cat /sys/devices/platform/applesmc.768/temp13_input',
    5,
    function(widget, stdout)
        local out = stdout:gsub("...[\n\r]", "")
        widget:set_markup_silently(out.."⁰c")
    end,
    wibox.widget.textbox()
)

local fan_speed = awful.widget.watch(
    'cat /sys/devices/platform/applesmc.768/fan1_input',
    5,
    function(widget, stdout)
        local out = stdout:gsub("[\n\r]", "")
        widget:set_markup_silently(out.." rpm")
    end,
    wibox.widget.textbox()
)

temperature.buttons = hwmon_buttons
fan_speed.buttons   = hwmon_buttons
-- }}}


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
                              if client.focus then
                                  client.focus:move_to_tag(t)
                              end
                          end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
                              if client.focus then
                                  client.focus:toggle_tag(t)
                              end
                          end)
)

-- {{{ textclock with popup calendar
local mytextclock = wibox.widget.textclock("%r", 1)
local month_calendar = awful.widget.calendar_popup.month()
month_calendar:attach( mytextclock, "tm" )
-- }}}

-- {{{
screen.connect_signal("request::desktop_decoration", function(s)
    -- {{{ tags
    awful.tag.add("1", {
        icon               = "/home/lenny/.config/awesome/assets/taglist/web.png",
        layout             = awful.layout.suit.tile,
        master_fill_policy = "master_width_factor",
        gap_single_client  = true,
        gap                = 15,
        screen             = s,
        selected           = true,
    })

    for key, name in ipairs {
        "search.png", "console.png", "doc.png",
        "chat.png", "video.png", "misc.png",
        "office.png", "music.png", "download.png"
    } do
        awful.tag.add(tostring(key + 1), {
            icon   = "/home/lenny/.config/awesome/assets/taglist/"..name,
            layout = awful.layout.suit.tile,
        })
    end
    -- }}}

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
       awful.button({ }, 1, function () awful.layout.inc( 1) end),
       awful.button({ }, 3, function () awful.layout.inc(-1) end),
       awful.button({ }, 4, function () awful.layout.inc( 1) end),
       awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- {{{ Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.noempty,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    id     = 'icon_role',
                    resize = true,
                    widget = wibox.widget.imagebox,
                },
                top    = dpi(7),
                bottom = dpi(7),
                left   = dpi(12),
                right  = dpi(12),
                widget = wibox.container.margin,
            },
            {
                {
                    wibox.widget.base.make_widget(),
                    id            = 'background_role',
                    forced_height = 1,
                    widget        = wibox.container.background,
                },
                top    = dpi(27.5),
                widget = wibox.container.margin
            },
            layout = wibox.layout.stack
        },
    }
    -- }}}

    -- {{{ Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.minimizedcurrenttags,
        buttons = gears.table.join(
            awful.button({ }, 1, function (c)
                c:emit_signal(
                    "request::activate",
                    "tasklist",
                    {raise = true}
                )
            end)
        ),
        widget_template = {
            {
                {
                    id     = 'icon_role',
                    widget = wibox.widget.imagebox,
                },
                left   = dpi(10),
                right  = dpi(10),
                top    = dpi(5),
                bottom = dpi(5),
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }
    -- }}}

    -- {{{ Create the wibox
    s.mywibox = awful.wibar({
        border_color = "#00000040",
        border_width = 1,
        position = "top",
        screen = s,
        height = 30,
        bg     = "#00000017"
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            {
                s.mytaglist,
                s.mytasklist,
                window_class,
                s.mypromptbox,
                layout = wibox.layout.fixed.horizontal
            },
            left = dpi(20),
            layout = wibox.layout.margin
        },
        { -- Middle widget
            mytextclock,
            layout = wibox.layout.fixed.horizontal
        },
        { -- Right widgets
            temperature,
            fan_speed,
            brightness,
            volume,
            battery,
            {
                s.mylayoutbox,
                top = dpi(5),
                bottom = dpi(5),
                right = dpi(5),
                widget = wibox.layout.margin
            },
            spacing = dpi(20),
            layout = wibox.layout.fixed.horizontal
        }
    }
    -- }}}
end)

-- }}}
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
