
local starlib = require('starlib')

local Item = class(function()

    function ctor(self, propId)
        self.propId = propId
    end

    function getPropId(self)
        return self.propId
    end
end)

print('class.Item', debug.dump(Item))

local ItemEquip = class(function()

    class.inherit(m(), Item)

    function ctor(self, propId, name)
        super.ctor(self, propId)
        self.name = name
    end

    function getName(self)
        return self.name
    end
end)

print('class.ItemEquip', debug.dump(ItemEquip, nil, 3))

local item = ItemEquip.new(1, 'item')
print('item', debug.dump(item))
-- print('item.getPropId', item:getPropId())
print('item.getName', item:getName())


local ItemFactory = static(function()
    function hello(self, msg)
        print('msg', msg)
        return msg
    end
end)

local msg = ItemFactory:hello('world')
print(msg)