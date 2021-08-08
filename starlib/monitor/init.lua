
local function clock()
    local startAt = os.clock()
    return function()
        return os.clock() - startAt
    end
end

local function run(name, num, fn)
    local use = clock()
    for i = 1, num do
        fn()
    end
    return string.format('monitor=%s, num=%s, use=%s', name, num, use())
end

local function compare(name, num, fns)
    local result = {}
    local min = math.huge
    for name, fn in pairs(fns) do
        local watch = clock()
        for i = 1, num do
            fn()
        end
        local use = watch()
        table.insert(result, {name, use})
        min = math.min(min, use)
        -- table.insert(report, string.format('    name=%s, use=%s', v[1], use()))
    end

    table.sort(result, function(a, b) return a[1] < b[1] end)

    local report = {}
    table.insert(report, string.format('monitor=%s, num=%s, min=%s', name, num, min))
    for _, v in ipairs(result) do
        table.insert(report, string.format('    name=%s, use=%s, efficiency=%.2f', v[1], v[2], v[2] / min))
    end

    return table.concat(report, '\n')
end

return {
    clock = clock,
    run = run,
    compare = compare,
}