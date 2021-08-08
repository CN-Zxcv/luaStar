
------ array parts ---------
function table.indexOf(t, x)
    for k, v in ipairs(t) do
        if v == x then
            return k
        end
    end
    return -1
end



------ table parts ---------
function table.includes(t, x)
    for k, v in pairs(t) do
        if v == x then
            return true
        end
    end
    return false
end