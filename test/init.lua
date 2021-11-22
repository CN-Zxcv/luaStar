

local starlib = require('starlib')
starlib.configure({
    paths = {'./starlib'},
    -- cpaths = {'./starlib/__luarocks/lib/lua/5.3'},
})

require('extension')
print('starlib', debug.dump(starlib))
starlib.unrequire()
require('extension')
