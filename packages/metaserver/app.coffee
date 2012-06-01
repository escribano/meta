path = require 'path'
express = require 'express'
require 'express-resource'
require 'express-namespace'
mongoose = require 'mongoose'

#require.paths.unshift path.join(__dirname, 'app')
#require.paths.unshift path.join(__dirname, 'lib')

metaServer = require './lib/base'
require './lib/scaffold'

app = metaServer.createServer()
app.namespace '/samples', ->
  app.get '/', to: {controller: 'samples'}
console.log app

require('./app/config').call app
mongoose.connect app.set('mongoose url')
metaServer.I18n.load path: '/app/locales'

require('./app/routes').call app
app.helpers require('./lib/base/helpers')
#app.helpers require('./app/helpers')

if require.main == module
  app.listen 4000
  console.log "Express server listening on port %d", app.address().port

module.exports = app