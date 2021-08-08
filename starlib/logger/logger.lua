
local innerlog = require('logger.innerlog')

local function defaultParseStack()
end

class('Logger', function()

    function m:ctor(name)
        self.category = name
        self.context = {}
        self.parseStack = defaultParseStack
        innerlog('Logger, ctor, category=%s, level=%s', self.category, self:getLevel())
    end

    function m:getLevel()
        -- return 
    end

    function m:setLevel()

    end

    function m:log(level, ...)
    end

    function m:d(...)
        self:log(LogLevel.Debug, ...)
    end

    function m:i(...)
        self:log(LogLevel.Info, ...)
    end

    function m:w(...)
        self:log(LogLevel.Warn, ...)
    end

    function m:e(...)
        self:log(LogLevel.Error, ...)
    end

    function m:f(...)
        self:log(LogLevel.Fatal, ...)
    end
end)