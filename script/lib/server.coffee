express = require 'express'


module.exports = (dir, port)->
  app = express()
  app.use express.static "#{__dirname}/../../#{dir}"
  app.listen port, ->
    console.log "serving assets on http://localhost:#{port}"
