
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

local function requireBasicLibs()
    require('starcore.require')
    require('extension')
    require('oop')
end

local function configure(opt)
    configurePath(opt.paths)
    configureCPath(opt.cpaths)
    requireBasicLibs()
end

configure({paths={'./starlib'}})

return {
    configure = configure,
    unrequire = function()
        -- loaded只是引用，改变这个值并不会改变 require 使用的表
        -- 我们无法直接设置那个表，所以要遍历
        for k, _ in pairs(package.loaded) do
            package.loaded[k] = nil
        end
    end,
}