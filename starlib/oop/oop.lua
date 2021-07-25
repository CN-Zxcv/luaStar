
function class(name, fn)
    local env = debug.getenv(fn)
    assert(env, 'no env')

    local m = env[name] or setmetatable({}, {__index = env})
    env[name] = m

    local _m = {
        __index = m
    }

    function m.inherit(super)
        m.super = super

        -- copy all functions for call efficiency
        for k, v in pairs(super) do
            if type(v) == 'function' then
                m[k] = v
            end
        end
    end

    function m.schema(schema)
        m._schema = schema
    end

    function m.new(...)
        local o = setmetatable({_data={}}, _m)
        o:ctor(...)
        return o
    end

    function m.ctor(self, ...)
    end

    debug.setenv(fn, m)
    fn()
end

return {
    class = class,
}