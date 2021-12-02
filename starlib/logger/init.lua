
local logger = require('logger.logger')
local output = require('logger.output')
logger.setOutput(output)

return {
    get = logger.new,
    setOutput = logger.setOutput,
}