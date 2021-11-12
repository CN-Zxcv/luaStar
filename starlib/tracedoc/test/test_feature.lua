

local starlib = require('starlib')
local tracedoc = require('tracedoc')
local monitor = require('monitor')

local Entity = class(function()
    function ctor(self)
        self.id = 0
    end

    function setId(id)
        self.id = id
    end
end)


local function _meta_next(obj, k)
    -- iterate raw first
    local v = nil
    if k == nil or rawget(obj, k) then
        while true do
            k, v = next(obj, k)
            if k == nil then
                break
            end
            if k ~= '_doc' then
                return k, v
            end
        end
    end

    -- then, iterate doc
    local v = nil
    local doc = rawget(obj, '_doc')
    if doc and (k == nil or doc[k]) then
        while true do
            k, v = next(doc, k)
            if k == nil then
                break
            end
            if not rawget(obj, k) then
                return k, v
            end
        end
    end
end

local _meta = {
    __pairs = function(obj)
        return _meta_next, obj
    end,
    __index = function(obj, k)
        local v = rawget(obj, k)
        if v ~= nil then
            return v
        end
        if not rawget(obj, '_doc') then
            return nil
        end
        return rawget(obj._doc, k)
    end
}



local function dump(doc)
    print('doc', debug.dump(doc))
    print('keys', debug.dump(doc._keys))
    print('changes', debug.dump(doc._changes))
    print('lastversion', debug.dump(doc._lastversion))
    print('tracedoc.dump', tracedoc.dump(doc))
end

-- local doc = tracedoc.new()
-- doc.entity = Entity.new()
-- dump(doc)

-- local chgs = tracedoc.commit(doc, {})
-- print('chgs', debug.dump(chgs))

-- dump(doc)


local obj = setmetatable({
    _doc = {
        a = 1,

        b = 1,

        c = {
            a = 1,
        },
    },
    b = 2,
}, _meta)
local doc = tracedoc.new()
doc.obj = obj
doc.c = {
    a = 1,
}
obj.a = 3


local chgs = tracedoc.commit(doc, {})

doc.c.a = 2
-- obj.c.a = 2
local chgs = tracedoc.commit(doc, {})
print('chgs', debug.dump(chgs))
-- dump(doc)
-- print('doc', debug.dump(doc))
