
local starlib = require('starlib')

local Entity = class(function()

    class.category(m(), 'save', function(t, k, v)
        
    end)

    class.schema(m(), {
        id = {type=Int, cate={'save'}},
    })

    function ctor(self, id)
        self.id = id
    end

end)