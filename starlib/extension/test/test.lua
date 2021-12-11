
local starlib = require('starlib')
local log = require('logger').get('test')

assert(string.lastIndexOf('a', '.') == -1)
assert(string.lastIndexOf('a.', '.') == 2)
assert(string.lastIndexOf('a.b.c', '.') == 4)


-- log.d(debug.dump(debug, 1))




-- local a = {}
-- a.a = a

-- print(dump(a))

_ENV = setmetatable({name='A'}, {__index=_G})

local function A(fn)
    print('hello')
    -- print(debug.dump(debug.getfenv(fn), 2))
end

A(function()
    a = 1
end)

log.d(debug.dump(debug.getfenv(A)))