

local luaStar = require('src')
luaStar.configure({
    paths = {'./src'},
    -- cpaths = {'./starlib/__luarocks/lib/lua/5.3'},
})

require('extension')
print('starlib', debug.dump(starlib))
