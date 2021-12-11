
_ENV = _G.debug

local tinsert = table.insert
local tconcat = table.concat

local function rvalue(x)
    local typename = type(x)
    if typename == 'string' then
        return string.format('%q', x)
    elseif typename == 'number' 
        or typename == 'boolean' 
        then
        return tostring(x)
    else
        return string.format('(%s)', type(x))
    end
end

local function lvalue(x)
    local typename = type(x)
    if typename == 'string' then
        return x
    elseif typename == 'number' then
        return string.format('[%s]', x)
    else
        return string.format('(%s)', x)
    end
end

local function runDump(ret, t, dumped, depth, max_depth)
    if type(t) == 'table' then
        if depth == max_depth then
            tinsert(ret, rvalue(t))
        elseif dumped[t] then
            tinsert(ret, string.format("(<dup>%s)", tostring(t)))
        else
            dumped[t] = true

            tinsert(ret, '{')
            tinsert(ret, string.rep(' ', depth * 2))
            tinsert(ret, '\n')
            local space = string.rep(' ', (depth + 1) * 2)
            for k, v in pairs(t) do
                tinsert(ret, space)
                tinsert(ret, lvalue(k))
                tinsert(ret, ' = ')
                runDump(ret, v, dumped, depth + 1, max_depth)
                tinsert(ret, '\n')
            end
            tinsert(ret, string.rep(' ', depth * 2))
            tinsert(ret, '}')
        end
    else
        tinsert(ret, rvalue(t))
    end
    return ret
end

function dump(t, depth)
    return tconcat(runDump({}, t, {}, 0, depth or 16))
end

if not getfenv then
    function getfenv(f)
        local cf, up = type(f) == 'function' and f or getinfo(f + 1, 'f').func, 0
        local name, val
        repeat
            up = up + 1
            name, val = getupvalue(cf, up)
        until name == '_ENV' or name == nil
        if val then
            return val
        end

        if type(f) == 'number' then
            f, up = f + 1, 0
            repeat
                up = up + 1
                name, val = getlocal(f, up)
            until name == '_ENV' or name == nil
            if val then 
                return val 
            end
        end
    end
end

if not setfenv then
    setfenv = function (f, t)
        f = type(f) == 'function' and f or getinfo(f + 1, 'f').func
        local up, name  = 0
        repeat
            up = up + 1
            name = getupvalue(f, up)
        until name == '_ENV' or name == nil
        if name then 
            upvaluejoin(f, up, function() 
                return t 
            end, 1) 
        end
        return f
    end
end