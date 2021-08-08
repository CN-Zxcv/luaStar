
local starlib = require('starlib')

assert(string.lastIndexOf('a', '.') == -1)
assert(string.lastIndexOf('a.', '.') == 2)
assert(string.lastIndexOf('a.b.c', '.') == 4)