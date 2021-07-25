
_G.starlib = _G.starlib or setmetatable({}, {__index = _G})
_ENV = _G.starlib

__PACKAGE_PATH__ = __PACKAGE_PATH__ or package.path
__PACKAGE_CPATH__ = __PACKAGE_CPATH__ or package.cpath

function configurePath(paths)
    if not paths then
        return
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
    local t = {}
    for _, path in pairs(paths) do
        table.insert(t, path .. '/?.so')
    end
    package.cpath = __PACKAGE_CPATH__ .. ';' .. table.concat(t, ';')
end

function configure(opt)
    configurePath(opt.paths)
    configureCPath(opt.cpaths)
    require('starcore.require')
    require('extension')
    require('logger')
end

configure({paths={'./starlib'}})

return {
    configure = configure,
    reload = function()
        package.loaded = {}
    end,
}