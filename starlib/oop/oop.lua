
local function mergeFunctions(child, super)
    for k, v in pairs(super) do
        if type(v) == 'function' then
            child[k] = v
        end
    end
end

local function class(mod, fn)
    if type(mod) == 'function' then
        mod, fn = nil, mod
    end

    local env = debug.getenv(fn)
    assert(env, 'no env')
    local m = mod or setmetatable({}, {__index = env})
    
    local _m = {
        __index = m
    }
    
    function m.ctor(self, ...)
    end

    function m.m()
        return m
    end

    debug.setenv(fn, m)()

    function m.new(...)
        local o = setmetatable({}, _m)
        o:ctor(...)
        return o
    end
    
    return m
end

local function iter(obj, k)
    -- iterate raw first
    local v = nil
    if k == nil or rawget(obj, k) then
        while true do
            k, v = next(obj, k)
            if k == nil then
                break
            end
            if k ~= '_doc' then
                return k, v
            end
        end
    end

    -- then, iterate doc
    local v = nil
    local doc = rawget(obj, '_doc')
    if doc and (k == nil or doc[k]) then
        while true do
            k, v = next(doc, k)
            if k == nil then
                break
            end
            if not rawget(obj, k) then
                return k, v
            end
        end
    end
end

local _class_mt = {
    __index = {
        inherit = function(child, super)
            child.super = super
            mergeFunctions(child, super)
        end,
        schema = function(child, schema)
            child.schema = schema
        end,
    },
    __call = function(_, ...)
        return class(...)
    end,
    __pairs = function(obj)
        return iter, obj
    end,
}

local function static(mod, fn)
    if type(mod) == 'function' then
        mod, fn = nil, mod
    end

    local env = debug.getenv(fn)
    assert(env, 'no env')
    local m = mod or setmetatable({}, {__index = env})

    debug.setenv(fn, m)()

    return m
end

local _static_mt = {
    __index = {
        inherit = function(child, super)
            child.super = super
            mergeFunctions(child, super)
        end,
    },
    __call = function(_, ...)
        return static(...)
    end,
    __pairs = function(obj)
        return iter, obj
    end
}

return {
    class = setmetatable({}, _class_mt),
    static = setmetatable({}, _static_mt),
}