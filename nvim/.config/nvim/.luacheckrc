-- Only allow symbols available in all Lua versions
std = "min"

-- This file itself
files[".luacheckrc"].ignore = { "111", "112", "131" }

-- Global objects defined by the C code
read_globals = {}

-- Globals
globals = {
  "vim", -- vim api
  "unpack", -- table.unpack
}

-- Do not cache
cache = false

-- Pretty print
color = true

-- vim: ft=lua:ts=2:sts=2:sw=2:et :
