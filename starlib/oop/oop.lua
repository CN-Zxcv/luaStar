
-- 基类的函数拷到子类上，减少调用消耗
-- 由此导致单独热更类需要专门处理，但是付出是可以接受的
local function mergeFunctions(child, super)
    for k, v in pairs(super) do
        if type(v) == 'function' then
            child[k] = v
        end
    end
end

local function class(name, fn)
    local env = debug.getenv(fn)
    assert(env, 'no env')

    local m = env[name] or setmetatable({}, {__index = env})
    env[name] = m

    local _m = {
        __index = m
    }

    function m.inherit(super)
        m.super = super
        mergeFunctions(m, super)
    end

    function m.ctor(self, ...)
    end

    function m.schema(schema)
        m._schema = schema
    end

    debug.setenv(fn, m)
    fn()

    function m.new(...)
        local o = setmetatable({_data={}}, _m)
        o:ctor(...)
        return o
    end

end

local function static(name, fn)
    local env = debug.getenv(fn)
    assert(env, 'no env')
    local m = env[name] or setmetatable({}, {__index = env})
    env[name] = m

    function m.inherit(super)
        m.super = super
        mergeFunctions(m, super)
    end

    debug.setenv(fn, m)
    fn()
end

return {
    class = class,
    static = static,
}