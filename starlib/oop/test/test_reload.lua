
local starlib = require('starlib')

local class2 = require('oop.test.test_reload_one')
print('xxxxxxxxx', debug.dump(class2))
print('Foo address', class2.Foo)


starlib.unrequire()

local class2 = require('oop.test.test_reload_one')
print('yyyyyyyyy', debug.dump(class2))
print('Foo address', class2.Foo)
