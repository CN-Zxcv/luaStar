
UnsetType = setmetatable({}, {__tostring = function() return '<UNSET>' end})
TraceType = setmetatable({}, {__tostring = function() return '<TRACE>' end})

local function docGet(doc, k)
    local v = doc._chgs[k]
    if v == nil then
        return doc._last[k]
    elseif v == UnsetType then
        return nil
    else
        return v
    end
end

local function markDirty(doc)
    if doc._dirty then
        return
    end
    doc._dirty = true
    return doc._parent and markDirty(doc._parent) 
end

local function docSet(doc, k, v)
    markDirty(doc)

    if type(v) == 'table' then
        local mt = getmetatable(v)
        if mt == nil then
            local t = doc._chgs[k] or doc._last[k]
            if getmetatable(t) ~= TraceType then
                -- 最后的版本不是table，创建一个
                t = new()
                t._parent = doc
                doc._chgs[k] = t
            elseif doc[k] == nil then
                -- 没有这个，创建一个
                t = new(t)
                t._parent = doc
                doc._chgs[k] = t
            end
            for k, v in pairs(v) do
                t[k] = v
            end
            return
        end
    end

    if v == nil then
        doc._chgs[k] = UnsetType
    else
        doc._chgs[k] = v
    end
end

local function docNext(doc, k)
    local v = nil

    local chgs = doc._chgs
    if k == nil or chgs[k] then
        while true do
            k, v = next(chgs, k)
            if k == nil then
                break
            end
            return k, v
        end
    end

    local last = doc._last
    while true do
        k, v = next(last, k)
        if k == nil then
            break
        end
        if not chgs[k] then
            return k, v
        end
    end
end

local _mt_doc = {
    -- __pairs = function(doc) return docNext, doc end,
    __index = docGet,
    __len = nil,
    __metatable = nil,
    __newindex = docSet,
    __metatable = TraceType,
}

function new(init)

    local doc = {
        _last = {},
        _chgs = {},
        _parent = false,
        _dirty = false,
    }
    setmetatable(doc, _mt_doc)

    if init then
        for k, v in pairs(init) do
            if getmetatable(v) == TraceType then
                doc[k] = new(v)
            else
                doc[k] = v
            end
        end
    end

    return doc
end

local function commitChgs(doc, ret, prefix)
    if not doc._dirty then
        return result
    end

    local last = doc._last
    local chgs = doc._chgs
    
    for k, v in pairs(chgs) do
        local mt = getmetatable(v)
        local key = prefix .. k
        if mt == TraceType then
            commitChgs(v, ret, key .. '.')
        elseif mt == UnsetType then
            ret.d[key] = v
        else
            ret.u[key] = v
        end
        last[k] = v
    end
    for k, v in pairs(last) do
        if getmetatable(v) == TraceType and v._dirty then
            commitChgs(v, ret, prefix .. k .. '.')
        end
    end

    doc._dirty = false
    doc._chgs = {}

    return ret
end

local function commit(doc, prefix)
    return commitChgs(doc, {u={},d={}}, prefix or '')
end

return {
    new = new,
    commit = commit,
}