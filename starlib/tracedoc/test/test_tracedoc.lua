local starlib = require('starlib')
local tracedoc = require('tracedoc')

local doc = tracedoc.new({})
local chgs = tracedoc.commit(doc)

print('--------- tracedoc change same value')
doc.a = 1
print(tracedoc.dump(doc))
print(debug.dump(tracedoc.commit(doc, {})))

print('--------- tracedoc change diff value')
doc.a = nil
print(tracedoc.dump(doc))
print(debug.dump(tracedoc.commit(doc, {})))

print('--------- getmetatable')
print(getmetatable({}))