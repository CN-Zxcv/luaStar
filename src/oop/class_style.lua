
---------------- 
-- module形式，5.2已经没有module，需要重新设计
module('Player', class('Entity'))

property = {
    pid = 0,
    name = 0,
}

function ctor(self, opt)
    playerMgr.add(self)
end

----------------
-- 使用do + _ENV ，直接使用_ENV 无法兼容lua 5.1

Player = class(Player, Entity)
do
    _ENV = Player

    property = {
        pid = 0,
        name = '',
    }

    function init(self)
        self.online = false
    end

    function ctor(self, opt)
    end
end

return {
    Player = Player,
}
-----------------
-- 
Player = class(Player, nil, function(m)
    m.proxy = {
        pid = 0,
        name = 0,
    }
    m.property = {

    }
    function m:ctor(opt)
    end
end)

return {
    Player = Player,
}
--------------------
-- 包含类型标注的类实现

class.addCategory('save', {
    enabled = function(m)
        return m.Saveable and m.Model
    end,
    on_changed = function(t, k, v)
        dbMgr.save(t.Model, k, v)
    end,
}
class.addCategory('display', {
    enabled = function(m)
        return m.Displayable and m.watchers
    end,
    on_changed = function(t, k, v)
        cliMgr.notify(t.watchers, k, v)
    end,
})

-- 类型标注
Schema('Artical', {
    pid = {type=Int, cate={'save', 'display'}},
    name = {type=Computed, cate={'display'}, depends={'pid'}, 
        compute = function(pid)
            return name   
        end,
    }},
    title = {type=String, default='unknown', cate={'save', 'display'}},
    comments = {
        {
            body=String, 
            date=Int
        },
    },
})

using('class')

namespace('class', function()
    class('Artical' , function()
        __Extend__('Object')
        __Schema__('Artical')

        function m:ctor()
        end
    end)
end)


----- 
-- 使用 namespace 还是 import 的方式