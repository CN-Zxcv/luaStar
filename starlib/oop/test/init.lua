
local starlib = require('starlib')

-- require('oop.test.env')

-- env.class(function()
-- end)

local oop = require('oop.oop')
local class = oop.class

class('Item', function()

    function ctor(self, propId)
        self.propId = propId
    end

    function getPropId(self)
        return self.propId
    end
end)

print('class.Item', debug.dump(Item))

class('ItemEquip', function()
    print('class.Item inherit', debug.dump(Item))
    inherit(Item)

    -- class 内置希望在这个位置执行，但是又希望使用inherit

    function ctor(self, propId, name)
        -- super.ctor(self, propId)
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
