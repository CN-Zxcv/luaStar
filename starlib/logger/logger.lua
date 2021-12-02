
local LogLevel = {
    Debug = 1,
    Info = 2,
    Warn = 3,
    Error = 4,
    Fatal = 5,
}

local LogPrefix = {}

Inited = Inited or false
Output = Output or nil

local function setOutput(fn)
    Output = fn
end

local function new(prefix)
    local ret = {}
    for name, level in pairs(LogLevel) do
        ret[string.lower(string.sub(name, 1, 1))] = function(...)
            Output(level, prefix, ...)
        end
    end
    return ret
end

local function init()
    if Inited then
        return
    end

    for name, lv in pairs(LogLevel) do
        LogPrefix[lv] = string.upper(string.sub(name, 1, 1))
    end
end
init()

return {
    init = init,
    new = new,
    LogLevel = LogLevel,
    LogPrefix = LogPrefix,
    setOutput = setOutput,
}