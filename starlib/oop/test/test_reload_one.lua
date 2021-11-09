local starlib = require('starlib')

Foo = class(Foo, function()

    function ctor(self, propId)
        self.propId = propId
    end
    
    function getPropId(self)
        return self.propId
    end
end)

print('class Foo', debug.dump(Foo))

return {
    Foo = Foo,
}