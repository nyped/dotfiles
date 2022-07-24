-- Garbage collector

local gears = require("gears")

gears.timer.start_new(10,
    function()
        collectgarbage("step", 20000)
        return true
    end
)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
