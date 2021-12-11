
local logger = require('logger.logger')
local Prefix = logger.LogPrefix

--[[
30 black
31 red
32 green
33 yellow
34 blue
35 magenta
36 cyan
37 white
--]]

local Color = {36,32,33,31,35}

local function output(lv, prefix, fmt, ...)
    local curDate = os.date('%Y%m%d %H:%M:%S')
    print(string.format("\27[%dm%s %s %s " .. (fmt or 'nil') .. "\27[0m", Color[lv], Prefix[lv], curDate, prefix, ...))
end

return output