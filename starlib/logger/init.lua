
local logger = require('logger.logger')

return {
    getLogger = function(name)
        return logger.getLogger(name)
    end
},