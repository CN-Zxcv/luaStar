
local log = require('starlib.logger').get(_NAME)
local fakefunc = misc.fakefunc

local WEAK_ALL = {__mode='kv', __metatable = false}

local function newStorage(weak)
    return setmetatable({}, weak)
end

_Prototype = newStorage(WEAK_ALL)

local falseMeta = {__metatable=false}
local proxymap = newStorage(WEAK_ALL)

local function newProxy(prototype)
    if prototype == true then
        local meta = {}
        prototype = setmetatable({}, meta)
        proxymap[prototype] = meta
        return prototype
    elseif proxymap[prototype] then
        return setmetatable({}, proxymap[prototype])
    else
        return setmetatable({}, falseMeta)
    end
end

local function savePrototype(p, meta)
    _Prototype[p] = meta
end

local function newPrototype(meta, super)
    local prototype = newProxy(true)
    local pm = getmetatable(prototype)
    savePrototype(prototype, pm)

    if meta then
        table.clone(meta, pm, true)
    end

    if pm.__metatable == nil then
        pm.__metatable = prototype
    end
    local name
    if type(pm.__tostring) == 'string' then
        name, pm.__tostring = pm.__tostring, nil
    end
    if pm.__tostring == nil then
        local addr = tostring(prototype)
        pm.__tostring = name and function()
            return string.format("<%s %s>", name, addr)
        end
    end

    if super then
        table.clone(_Prototype[super], pm, false)
    end

    log.d("%s created", name or 'anonymous')

    return prototype
end


local prototype = newPrototype({
    __tostring = 'prototype',
    __index = {
        newObject = function(self, t)
            return setmetatable(t or {}, _Prototype[self])
        end,
        newProxy = newProxy,
        iterMethods = function(self)
            local methods = _Prototype[self] and _Prototype[self].__index
            print(debug.dump(methods))
            if not methods or type(methods) ~= 'table' then
                return fakefunc, self
            end
            return function(self, n)
                local k, v = next(methods, n)
                while k and type(v) ~= 'function' do
                    k, v = next(methods, k)
                    return k, v
                end
            end, self
        end,
    },
    __newindex = readonly,
    __call = function(self, meta, super)
        print(self)
        return newPrototype(meta, super)
    end
})

return prototype