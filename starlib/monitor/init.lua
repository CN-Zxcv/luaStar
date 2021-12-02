
local function clock()
    local startAt = os.clock()
    return function()
        return os.clock() - startAt
    end
end

local function run(name, num, fn)
    local use = clock()
    for _ = 1, num do
        fn()
    end
    return string.format('monitor=%s, num=%s, use=%s', name, num, use())
end

--[[
fns = {
    what = func()
    end,
}
-- ]]
local function compare(name, num, fns)
    local raw = {}

    local min = math.huge
    collectgarbage('stop')
    local loop = 10
    for _ = 1, loop do
        for fname, fn in pairs(fns) do
            collectgarbage()
            local watch = clock()
            for _ = 1, num do
                fn()
            end
            local use = watch()
            local t = raw[fname]
            if not t then
                t = {}
                raw[fname] = t
            end
            table.insert(t, use)
        end
    end
    collectgarbage('restart')

    local result = {}
    local cut = loop * 0.2
    local nameMaxLen = 0
    for k, v in pairs(raw) do
        table.sort(v)
        local sum = 0
        for i = cut, loop - cut do
            sum = sum + v[i]
        end
        local n = sum / (loop - cut * 2)
        table.insert(result, {k, n})
        min = math.min(min, n)
        nameMaxLen = math.max(nameMaxLen, string.len(k))
    end

    table.sort(result, function(a, b) return a[1] < b[1] end)

    local report = {}
    table.insert(report, string.format('monitor=%s, num=%s, loop=%s, min=%.4f', name, num, loop, min))
    for _, v in ipairs(result) do
        table.insert(report, string.format('    name=%-'.. nameMaxLen ..'s, use=%.4f, efficiency=%.2f', v[1], v[2], v[2] / min))
    end

    return table.concat(report, '\n')
end

return {
    clock = clock,
    run = run,
    compare = compare,
}
