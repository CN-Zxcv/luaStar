
print(...)

for k, v in pairs(arg) do
    print(k, v)
end

require('extendlib/debug')
require('extendlib/b')

print(dump(package.loaded, nil, 1))
print(a)

-- dofile('./vigalib/extendlib/debug.lua')

local f, e = io.open('./debug_.lua', 'w+')
f:write('hello')
print(e)
print(f:read())
-- dofile('../debug.lua')
-- reload('extendlib/debug')


-- 支持相对路径加载
-- 可以配置工程目录，工程目录下的代码无法访问工程目录外的目录，除非有配置映射
-- 工程目录可以嵌套，上层目录可以直接访问下层的，也可以通过配置映射减少路径长度
-- 放弃module，采用靠近lua53推荐的return导出的方式，但是依然要支持热更
-- package.loaded使用`绝对路径`(依然是相对根目录)的方式

function import(name)
    local path = realpath(name)
    if package.imported[path] then
        return package.imported[path]
    end
    local loader = find_loader(name)
    local env = package.imported[path] or {
        _FILE = path,
        _M = {},
    }
    package.imported[path] = loader(env)
end

function reload()
    package.imported = {}
end

----------- 
local debug = import('../debug')
local B = import('extend')

do
    local Foo = class()
end
function class(fn)
    debug.getenv()
end

class(Foo , function(m)
    _property = {}

    function m:init()
    end
    function m:ctor()
    end
end)

return {
    Foo = Foo,
}