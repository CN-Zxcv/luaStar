

function string.lastIndexOf(s, pattern, init)
    local i = -1

    local startIdx, lastIdx = nil, (init or 1) - 1
    repeat
        startIdx, lastIdx = string.find(s, pattern, lastIdx + 1, true)
        if startIdx then
            i = startIdx
        end
    until not startIdx

    return i
end