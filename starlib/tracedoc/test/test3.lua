
local starlib = require('starlib')
local tracedoc = require('tracedoc')
local monitor = require('monitor')

do
    local tt = tracedoc.new({a=1})
    -- local num = 100000
    -- print(monitor.run('tracedoc.get', num, function()
    --     tt.a = 1
    -- end))

    local pt = {}
    -- print(monitor.run('plain.get', num, function()
    --     pt.a = 1
    -- end))

    local mt = setmetatable({_data={}}, {
        __index = function(t, k)
            return t._data[k]
        end,
        __newindex = function(t, k, v)
            t._data[k] = v
        end,
    })

    print(monitor.compare('set', 1000000, {
        tracedoc = function()
            tt.a = 1
        end,
        plain = function()
            pt.a = 1
        end,
        meta = function()
            mt.a = 1
        end,
    }))

    print(monitor.compare('get', 1000000, {
        tracedoc = function()
            local a = tt.a
        end,
        plain = function()
            local a = pt.a
        end,
        meta = function()
            local a = mt.a
        end,
    }))
end

