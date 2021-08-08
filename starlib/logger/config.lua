
local innerlog = require('logger.innerlog')

local not = function(a)
    return not a
end

local anObject = function(a)
    return type(a) == 'table'
end

local validIdentifier = function()
end


local function configure(candidate)
    innerlog('')
end