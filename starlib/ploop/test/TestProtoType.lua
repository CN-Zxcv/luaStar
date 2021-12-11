
local _ = require('starlib')
local log = require('starlib.logger').get('TestProtoType')

local prototype = require('starlib.ploop.Prototype')

local proxy = prototype({
    __index = function(self, key)
        return rawget(self, '__' .. key)
    end,
    __newindex = function(self, key, value)
        rawset(self, '__' .. key, value)
    end,
    __tostring = 'myproxy'
})
print(prototype)

log.d(prototype)
log.d(proxy)


local obj = prototype.newObject(proxy)
obj.name = "test"
log.d('name %s', obj.name)
log.d('__name %s', obj.__name)

for k, v in prototype.iterMethods(prototype) do
    log.d("%s %s", k, v)
end