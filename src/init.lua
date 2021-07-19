
_G.starlib = _G.starlib or setmetatable({}, {__index = _G})
_ENV = _G.starlib

__PACKAGE_PATH__ = __PACKAGE_PATH__
__PACKAGE_CPATH__ = __PACKAGE_CPATH__

function configurePath(paths)
    if not paths then
        return
    end
    if not __PACKAGE_PATH__ then
        __PACKAGE_PATH__ = package.path
    end
    local t = {}
    for _, path in pairs(paths) do
        table.insert(t, path .. '/?.lua')
        table.insert(t, path .. '/?/init.lua')
    end
    package.path = __PACKAGE_PATH__ .. ';' .. table.concat(t, ';')
end

function configureCPath(paths)
    if not paths then
        return
    end
    if not __PACKAGE_CPATH__ then
        __PACKAGE_CPATH__ = package.cpath
    end
    local t = {}
    for _, path in pairs(paths) do
        table.insert(t, path .. '/?.so')
    end
    package.cpath = __PACKAGE_CPATH__ .. ';' .. table.concat(t, ';')
end

return {
    configure = function(opt)
        configurePath(opt.paths)
        configureCPath(opt.cpaths)
        require('starcore.require')
        require('logger')
    end
}