
local innerlog = require('logger.innerlog')
local appender = require('logger.appender')

local LogLevel = {
    Debug = 1,
    Info = 2,
    Warn = 3,
    Error = 4,
    Fatal = 5,
}



static('log4lua', function()
    enabled = enabled or false

    function m:getLogger(category)
        if not enabled then
            self:configure(os.getenv('LOG4LUA_CONFIG') or {
                appenders = {out = {type = 'stdout'}}
                categories = {default = {appenders = {'out'}, level='OFF'}}
            })
        end
        return Logger.new(category || 'default')
    end

    function m:configure(config)
        if type(config) == 'string' then
            config = require(config)
        end
        innerlog('Configure is %s', debug.dump(config))
        enabled = true
    end

    function m:shutdown(cb)
        innerlog('Shutdown called, Disabling all log writing')
        enabled = false
        appender:shutdown(cb)
    end

end)