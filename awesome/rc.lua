-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

naughty.config.defaults = {
    timeout = 10,
    text = "No content",
    ontop = true,
    margin = dpi(5),
    border_width = dpi(1),
    position = "bottom_right"
}


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%r", 1)

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
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

local class = wibox.widget.textbox('No name')

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    awful.tag.add("1", {
            icon               = "/home/lenny/.config/awesome/assets/taglist/web.png",
            layout             = awful.layout.suit.spiral.dwindle,
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
            layout = awful.layout.suit.spiral.dwindle,
        })
    end


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
    -- Create a taglist widget
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

    -- Create a tasklist widget REMOVEME
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

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top", screen = s, height = 30, border_width = 1,
        border_color = "#b3b3b3", bg = "#e4e4e4"
    })

    local bat = wibox.widget {
        {
            id = "wrap",
            {
                id = "logo",
                val = 10,
                charging = false,
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
        update_meta = function(self, input)
            local res = input:gsub("[\n\r]", "")
            self.wrap.logo.charging = (res == "Charging") and true or false
        end
    }

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            {
                layout = wibox.layout.fixed.horizontal,
                --mylauncher,
                s.mytaglist,
                s.mytasklist,
				{
					class,
					left = dpi(20),
					layout = wibox.layout.margin
				},
                s.mypromptbox,
            },
            left = dpi(20),
            layout = wibox.layout.margin
        },
        { -- Middle widget
            layout = wibox.layout.fixed.horizontal,
            mytextclock
        },
        { -- Right widgets
            awful.widget.watch(
                'cat /sys/devices/platform/applesmc.768/temp13_input',
                5,
                function(widget, stdout)
                    local out = stdout:gsub("...[\n\r]", "")
                    widget:set_markup_silently(out.."⁰c")
                end,
                wibox.widget.textbox()
            ),
            awful.widget.watch(
                'cat /sys/devices/platform/applesmc.768/fan1_input',
                5,
                function(widget, stdout)
                    local out = stdout:gsub("[\n\r]", "")
                    widget:set_markup_silently(out.." rpm")
                end,
                wibox.widget.textbox()
            ),
            awful.widget.watch(
                'cat /sys/class/power_supply/BAT0/capacity',
                1,
                function(widget, stdout)
                    local out = stdout:gsub("[\n\r]", "")
                    local image = nil

                    awful.spawn.easy_async_with_shell("cat /sys/class/power_supply/BAT0/status",
                        function(s)
                            bat:update_meta(s)
                        end
                    )

                    widget.percentage:set_markup_silently(out.."%")

                    if out == "100" then
                        image  = gears.surface.load_uncached(
                            beautiful.icon_path .. "battery/battery-100.png"
                        )
                        widget.percentage:set_markup_silently("")
                    elseif bat.wrap.logo.charging then
                        bat.wrap.logo.val = ((bat.wrap.logo.val + 10) > 100) and 10 or (bat.wrap.logo.val + 10)
                        image  = gears.surface.load_uncached(
                            beautiful.icon_path .. "battery/battery-charging-" .. tostring(bat.wrap.logo.val) .. ".png"
                        )
                    else
                        image  = gears.surface.load_uncached(
                            beautiful.icon_path .. "battery/battery-" .. tostring(math.floor(tonumber(out)/10) * 10) .. ".png"
                        )
                    end

                    bat.wrap.logo.image = image
                end,
                bat
            ),
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
end)

client.connect_signal("focus", function (c)
	if c.class == nil then
		awful.spawn.easy_async_with_shell(
			"ps -p "..tostring(c.pid).." -o comm= 2>/dev/null",
			function(out)
				class:set_markup_silently(out:gsub("^%l", string.upper))
			end
		)
	else
		name = c.class:gsub("^%l", string.upper)
		class:set_markup_silently(name)
	end
end
)

client.connect_signal("unfocus", function (c)
	class:set_markup_silently("")
end
)
--
-- Keybinds
require("keys")

-- Rules
require("rules")

local target = "7"

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

--client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
--client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- add gaps
-- {{{
beautiful.gap_single_client = true
beautiful.useless_gap = 10
-- }}
