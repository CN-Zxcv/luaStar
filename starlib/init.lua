
_G.starlib = _G.starlib or setmetatable({}, {__index = _G})
_ENV = _G.starlib

__PACKAGE_PATH__ = __PACKAGE_PATH__ or package.path
__PACKAGE_CPATH__ = __PACKAGE_CPATH__ or package.cpath

local function configurePath(paths)
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

local function configureCPath(paths)
    if not paths then
        return
    end
    local t = {}
    for _, path in pairs(paths) do
        table.insert(t, path .. '/?.so')
    end
    package.cpath = __PACKAGE_CPATH__ .. ';' .. table.concat(t, ';')
end

function requireBasicLibs()
    require('starcore.require')
    require('extension')
    require('oop')
end

function configure(opt)
    configurePath(opt.paths)
    configureCPath(opt.cpaths)
    requireBasicLibs()
end

configure({paths={'./starlib'}})

return {
    configure = configure,
    reload = function()
        package.loaded = {}
    end,
}