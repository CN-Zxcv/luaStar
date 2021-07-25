local debug = _G.debug

local function mkSpace(num)
    local fmt = string.format("%%%d.%ds", num, num)
    return string.format(fmt, " ")
end

local function rvalueToStr(x)
    if type(x) == 'string' then
        return string.format('%q', x)
    else
        return tostring(x)
    end
end

local function lvalueToStr(x)
    local name = type(x)
    if name == 'string' then
        if tonumber(x) then
            return string.format('[%q]', x)
        else
            return x
        end
    elseif name == 'number' then
        return tostring(x)
    else
        return string.format('[(%s:%s)]', name, tostring(x))
    end
end

function debug.dump(t, step, depth)
    local str = ""
    step = step or 0
    if type(t) == "table" then

        if step == 0 then 
            str = "{\n" 
        end
    
        if depth and depth == 0 then
            str = str .. string.format("%s...(table)\n", mkSpace(step * 2 + 2))
        else
            for k, v in pairs(t) do
                if type(v) == "table" then
                    str = str..string.format("%s%s = {\n", mkSpace(step*2+2), lvalueToStr(k))
                    str = str..debug.dump(v, step+1, depth and depth - 1)
                    str = str..string.format("%s}\n", mkSpace(step*2+2))
                else
                    str = str..string.format("%s%s = %s\n", mkSpace(step*2+2), lvalueToStr(k), rvalueToStr(v))
                end
            end
        end

        if step == 0 then
            if str == "{\n" then 
                str = "{ " 
            end
            
            str = string.format("%s}", str)
        end

    elseif type(t) == 'nil' then
        -- nothing
        str = str .. 'nil'
    else
        str = str..string.format("%s%s", mkSpace(step*2), rvalueToStr(t))
    end
	
    return str
end

function setenv(fn, env)
    for i = 1, math.huge do
        local n = debug.getupvalue(fn, i)
        if n == '_ENV' then
            debug.upvaluejoin(fn, i, function() return name end, 1)
            debug.setupvalue(fn, i, env)
        elseif not n then
            break
        end
    end
    return fn
end

function getenv(fn)
    for i = 1, math.huge do
        local n, v = debug.getupvalue(fn, i)
        if n == '_ENV' then
            return v
        elseif not n then
            break
        end
    end
end