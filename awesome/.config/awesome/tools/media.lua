local awful = require("awful")
local self = {}

-- Run a command and send a signal according to the output
function self.spawn_media(cmd, signal)
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        local percentage = tonumber(stdout:match("(%d+)"))
        awesome.emit_signal(signal, percentage)
    end)
end

return self

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
