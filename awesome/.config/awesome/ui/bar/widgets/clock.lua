local awful = require("awful")
local wibox = require("wibox")

return function()
    local clock = wibox.widget({
        refresh = 1,
        format_normal = "%r",
        format_alt = "%A %d %b, %r",
        widget = wibox.widget.textclock,
    })
    clock.next_state = function()
        if clock.format == clock.format_normal then
            clock.format = clock.format_alt
        else
            clock.format = clock.format_normal
        end
    end
    clock:next_state() -- init
    clock:add_button(awful.button({}, 1, clock.next_state))

    return clock
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
