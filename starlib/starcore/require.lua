-- 替换require lua加载，实现
-- 1.每个文件的环境独立，而不是默认的使用全局环境
-- 2.文件路径即模块名

local function acquireModule(name, path)
    name = string.gsub(name, '/', '.')
    local env = _G
    for match in string.gmatch(name .. '.', '(.-)%.') do
        if not env[match] then
            env[match] = {}
        end
        env = env[match]
    end
    if path then
        setmetatable(env, {__index = _G})
        env._FILE = path
        env._NAME = name
    end
    return env
end

local function searchersLua(name)
    local path, msg = package.searchpath(name, package.path)
    if not path then
        return msg
    end
    local env = acquireModule(name, path)
    local chunk, msg = loadfile(path, nil, env)
    return chunk or msg
end

package.searchers[2] = searchersLua