
function class(fn)
    for i = 1, 3 do
        print('class. getinfo', i, debug.dump(debug.getinfo(i)))
    end

    for i = 1, 3 do
        print('class. getupvalue', i, debug.getupvalue(class, i))
    end

    for i = 1, 3 do
        print('fn. getupvalue', i, debug.getupvalue(fn, i))
    end

    print('fn. getenv', debug.getenv(fn))

    local inner_a = 1

    local function inner()
    end

    for i = 1, 3 do
        print('inner. getupvalue', i, debug.getupvalue(inner, i))
    end
end

local a = 1
class(function()
    a = 2
    print(a)
end)