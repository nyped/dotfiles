local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- {{{ Volume signals
-- https://github.com/JavaCafe01/dotfiles/blob/master/config/awesome/signal/volume.lua

local volume_old = -1
local muted_old = -1
local function emit_volume_info()
    -- Get volume info of the currently active sink
    -- The currently active sink has a star `*` in front of its index
    -- In the output of `pacmd list-sinks`, lines +7 and +11 after "* index:"
    -- contain the volume level and muted state respectively
    -- This is why we are using `awk` to print them.
    awful.spawn.easy_async_with_shell(
        "pacmd list-sinks | awk '/\\* index: /{nr[NR+7];nr[NR+11]}; NR in nr'",
        function(stdout)
            local volume = stdout:match("(%d+)%% /")
            local muted = stdout:match("muted:(%s+)[yes]")
            local muted_int = muted and 1 or 0
            local volume_int = tonumber(volume)
            -- Only send signal if there was a change
            -- We need this since we use `pactl subscribe` to detect
            -- volume events. These are not only triggered when the
            -- user adjusts the volume through a keybind, but also
            -- through `pavucontrol` or even without user intervention,
            -- when a media file starts playing.
            if volume_int ~= volume_old or muted_int ~= muted_old then
                awesome.emit_signal("volume_change", volume_int, muted)
                volume_old = volume_int
                muted_old = muted_int
            end
        end
    )
end

-- Run once to initialize widgets
emit_volume_info()

-- Sleeps until pactl detects an event (volume up/down/toggle mute)
local volume_script = [[
    bash -c "
    LANG=C pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on sink #\"
    "]]

-- Kill old pactl subscribe processes
awful.spawn.easy_async({
    "pkill",
    "--full",
    "--uid",
    os.getenv("USER"),
    "^pactl subscribe",
}, function()
    -- Run emit_volume_info() with each line printed
    awful.spawn.with_line_callback(volume_script, {
        stdout = function(_)
            emit_volume_info()
        end,
    })
end)

-- }}}

-- {{{ Player signals
local player_script = [[
    bash -c "
        key='{{playerName}}|{{status}}|{{mpris:artUrl}}|{{title}}|{{artist}} - {{album}}';
        destination=/tmp/spotify_cover.png;

        playerctl --follow metadata --format \"$key\" | {
          while IFS='|' read -r player status url title info; do
            if [ \"$player\" != spotify ]; then
                continue
            fi
            if [ -z \"$url\" ]; then
              cover=/home/lenny/dotfiles/awesome/theme/assets/player/cover.png
            else
              curl -sL \"$url\" -o $destination &>/dev/null
              cover=$destination
            fi

            if [ -z \"$title\" ]; then
              title=\"-\"
            fi

            if [ -z \"$info\" ]; then
              info=\"Not playing\"
            fi

            echo \"player_status_update:$status\"
            echo \"player_cover_update:$cover\"
            echo \"player_text_update:$title\"
            echo \"player_info_update:$info\"
          done
        }
    "
]]

awful.spawn.easy_async({
    "pkill",
    "--full",
    "--uid",
    os.getenv("USER"),
    "^playerctl",
}, function()
    awful.spawn.with_line_callback(player_script, {
        stdout = function(line)
            local out = line:gsub("[\n\r]", "")
            local signal_name, updated_value = out:match("(.+):(.+)")
            awesome.emit_signal(signal_name, updated_value)
        end,
    })
end)

awesome.connect_signal("player_text_update", function(val)
    player_title = val
end)

awesome.connect_signal("player_info_update", function(val)
    player_info = val
end)

awesome.connect_signal("player_cover_update", function(path)
    player_cover = gears.surface.load_uncached(path)
end)
-- }}}

-- {{{ Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if
        awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position
    then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)
-- }}}

-- {{{ Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate({ context = "mouse_enter", raise = false })
end)
-- }}}

-- {{{ Floating windows on top
client.connect_signal("property::floating", function(c)
    c.ontop = c.floating
end)
-- }}}

-- {{{ Layouts
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair.horizontal,
        awful.layout.suit.fair,
    })
end)
-- }}}

-- {{{ Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper({
        screen = s,
        widget = {
            horizontal_fit_policy = "fit",
            vertical_fit_policy = "fit",
            image = beautiful.wallpaper,
            widget = wibox.widget.imagebox,
        },
    })
end)
-- }}}

-- {{{ Theme change
local function fetch_theme()
    awful.spawn.easy_async_with_shell("cat /home/lenny/.t", function(stdout)
        -- cleaning up the string
        local out = stdout:gsub("[\n\r]", "")
        -- update global variable
        theme_name = out
        -- sending the signal
        awesome.emit_signal("theme_change", out)
    end)
end

-- Update all themes
awesome.connect_signal("request::fetch_theme", fetch_theme)

-- initialisation
fetch_theme()
-- }}}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
