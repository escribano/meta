express = require 'express'
#coffeekup = require 'coffeekup'
#browserify = require 'browserify'
I18n = require '../lib/base/i18n'


module.exports = ->

  @configure ->
    @set 'views', __dirname + '/views'
    #@register '.coffee', coffeekup
    @set 'controllers path', __dirname + '/controllers'
    
    # register template
    @set 'view engine', 'jade'
    #@set 'view engine', 'coffee'
    #@set('view options', { layout: false })
    #@set 'hints', false # mostly annoying
    
    @use express.cookieParser()
    @use express.session(secret: "0123456789")
    
    @use express.bodyParser()
    @use express.methodOverride()
    
    # logger
    @configure 'development', ->
      @use(express.logger('  \033[90m:method\033[0m \033[36m:url\033[0m \033[90m:response-time\033[0m \033[90m:status\033[0m'))
      
    #i18n
    @use I18n.middleware
    @helpers I18n.helpers
    
    # database
    @configure 'development', ->
      @set 'mongoose url', 'mongodb://localhost/metaexpress_development'

    @configure 'test', ->
      @set 'mongoose url', 'mongodb://localhost/metaexpress_test'

    @configure 'production', ->
      @set 'mongoose url', 'mongodb://localhost/metaexpress_production'

    ###
    @use browserify
      mount: '/browserify.js'
      require: ['underscore', 'jquery-browserify']
      entry: "#{__dirname}/client/entry.coffee"
    ###
    
    @use express.favicon()
    
    #@use @router
    @use express.static(__dirname + '/../app/public')
    
  
  # Per environment configuration
  # error handling
  @configure 'development', ->
    @use express.errorHandler(dumpExceptions: true, showStack: true)

  @configure 'test', ->
    @use express.errorHandler(dumpExceptions: true, showStack: true)

  @configure 'production', ->
    @use express.errorHandler()
