
_ENV = _G.table

------ array parts ---------
function indexOf(t, x)
    for k, v in ipairs(t) do
        if v == x then
            return k
        end
    end
    return -1
end



------ table parts ---------
function includes(t, x)
    for k, v in pairs(t) do
        if v == x then
            return true
        end
    end
    return false
end

-- 清空table
function wipe(t)
    for k, _ in pairs(t) do
        t[k] = nil
    end
end

-- 浅拷贝
function dup(t)
    ret = {}
    for k, v in pairs(t) do
        ret[k] = v
    end
    return ret
end

local function runCopy(t, cache)
    if type(t) ~= 'table' then
        return t
    elseif cache[t] then
        return cache[t]
    end
    local ret = {}
    cache[t] = ret
    for k, v in pairs(t) do
        ret[k] = runCopy(v, cache)
    end
    return ret
end

-- 深拷贝
function copy(t)
    return runCopy(t, {})
end

local function runClone(t, ret, override, cache)
    cache[t] = ret
    for k, v in pairs(t) do
        if override or ret[k] == nil then
            if cache[v] then
                ret[k] = cache[v]
            elseif type(v) == 'table' then
                local mt = getmetatable(v)
                if mt == nil then
                    ret[k] = runClone(v, {}, override, cache)
                else
                    assert(false, 'TODO inherit metatable')
                    -- local fn = getPrototypeMethod(mt, 'Clone')
                    -- fn = fn and fn(v, mt) or v
                    -- if cache then cache[v] = fn end
                    -- ret[k] = fn
                end
            else
                ret[k] = v
            end
        elseif type(v) == 'table' and type(ret[k]) == 'table' and getmetatable(v) == nil and getmetatable(ret[k]) == nil then
            runClone(v, ret[k], override, cache)
        end
    end
    return ret
end

-- 复制（meta也会设置过去）
function clone(t, ret, override)
    if override == nil then
        override = true
    end
    return runClone(t, ret or {}, override, {})
end