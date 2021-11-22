
local starlib = require('starlib')
local trace = require('tracedoc.test.trace')

local doc = trace.new()

print('-------- set doc')
doc.a = 1
print('dump')
print(debug.dump(doc, nil, 5))

print('commit')
print(debug.dump(trace.commit(doc)))

print('-------- unset doc')
doc.a = nil
print('dump')
print(debug.dump(doc, nil, 5))

print('commit')
print(debug.dump(trace.commit(doc)))

print('-------- set doc table')

doc.a = {a = 1}
trace.commit(doc)
print('commit dump')
print(debug.dump(doc, nil, 10))


doc.a.b = 1
print('dump')
print(debug.dump(doc, nil, 10))

print('commit')
print(debug.dump(trace.commit(doc)))