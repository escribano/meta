#ExpressRouter = require 'express/lib/router'
#express = require 'express'
Controller = require './controller'


# A definition-to-middleware made f so that
# the end user can be able to customize it if he has to.
#
#@api public
class MiddlewareDefinition

  # Path prefix of controller directories
  # If controller are in "/app/controllers" and "/app" is in the require path,
  # then set to "controllers"
  #
  # @api public
  #@controllersPath: 'controllers'
  #@controllersPath: @app.set 'controllers path'

  
  # Create a MiddlewareDefinition from a function/string/object
  #
  # @cb {Function|String|Object} the router callback function or controller-defining string/object
  # @api public
  constructor: (@cb, @app) ->
  
  # Returns a Connect middleware for this definition
  #
  # @api public
  toMiddleware: ->
    switch typeof @cb
      when 'function'
        Controller.toMiddleware @cb
      when 'string'
        [controller, action] = @cb.split '#'
        MiddlewareDefinition.resolveMiddleware controller, action
      when 'object'
        {controller, action} = @cb
        console.log controller
        MiddlewareDefinition.resolveMiddleware controller, action
      else
        throw new Error("unknown route endpoint #{@cb}")
  
  # Validates the existence of controller and returns the resolved middleware
  # 
  # @controller {String} the controller name
  # @action {String} the controller action (or skip if rest)
  # @api public
  @resolveMiddleware: (controller, action) ->
    throw new Error("cannot resolve controller") unless controller?
    controller = @findController controller
    action = 'index' unless action?
    controller.toMiddleware action
    
  # Requires the given controller based on the controllersPath configuration
  #
  # @controller {String} the controller name
  # @api public
  #@findController: (controller) ->   
  #  require("#{@controllersPath}/#{controller}")
    
  # Requires the given controller based on the "controllers path" configuration
  #
  # @param {String} controller - the controller name
  # @return {Object} the controller class
  # @api public
  @findController: (controller) ->
    controllersPath = @app.set 'controllers path'
    throw new Error("please configure controllers path") unless controllersPath?
    require "#{controllersPath}/#{controller}"


# Returns a function that conforms to Express router api, that wraps the provided "cb" function or controller.
# If "cb" is a function, it is executed in a Context object instance, at req time.
# If it's a controller it is executed in the controller object.
#
# Route function callback example:
#
#     # routes.coffee
#     @get '/', to ->
#       @title = 'Express'
#       @render 'index'
#
#     # index.eco
#     <h1><%= @title %></h1>
#
# Controller callback example:
#
#     # routes.coffee
#     @get '/', to 'tweets#index'
#     @get '/create', to controller: 'tweets', action: 'create'
#
#@cb {Function|String|Object} the router callback function or controller-defining string/object
#@api public
#to = (cb) -> new MiddlewareDefinition(cb).toMiddleware() # TODO: namespace, module


# A router with advanced routing dsl capabilities
class Router #extends ExpressRouter


  #constructor: ->
  constructor: (@app) ->
    #super
    
    # paths to controller actions
    #@to = {} # @to.users.create(id: 10)
    
    # named paths
    @at = {} # @at.download_file(name: 'file.txt')
  
  test: ->
    console.log 'inside router'
    console.log typeof @app
    
  #
  # Returns a Connect middleware for this definition
  #
  # @api public
  toMiddleware: (cb) ->
    switch typeof cb
      when 'function'
        Controller.toMiddleware cb
      when 'string'
        [controller, action] = cb.split '#'
        #MiddlewareDefinition.resolveMiddleware controller, action
        @_resolveControllerAction controller, action
      when 'object'
        {controller, action} = cb
        #console.log controller
        #MiddlewareDefinition.resolveMiddleware controller, action
        @_resolveControllerAction controller, action
      else
        throw new Error("unknown route endpoint #{@cb}")
        
  # Returns a function that conforms to Express router api, that wraps the provided "cb" function or controller.
  # If "cb" is a function, it is executed in a Context object instance, at req time.
  # If it's a controller it is executed in the controller object.
  #
  # Route function callback example:
  #
  #     # routes.coffee
  #     @get '/', to ->
  #       @title = 'Express'
  #       @render 'index'
  #
  #     # index.eco
  #     <h1><%= @title %></h1>
  #
  # Controller callback example:
  #
  #     # routes.coffee
  #     @get '/', to 'tweets#index'
  #     @get '/create', to controller: 'tweets', action: 'create'
  #
  #@cb {Function|String|Object} the router callback function or controller-defining string/object
  #@api public
  to: (cb) -> 
    #console.log 'inside to'
    #console.log typeof @app
    #new MiddlewareDefinition(cb, @app).toMiddleware() # TODO: namespace, module
    #mid = new MiddlewareDefinition(cb, @app)
    #console.log typeof @app
    #console.log typeof mid.app
    #mid.toMiddleware()
    #@toMiddleware(cb)
    switch typeof cb
      when 'function'
        #Controller.toMiddleware cb
        #Controller.middleware to
        Controller.middleware cb
      when 'string'
        [controller, action] = cb.split '#'
        #MiddlewareDefinition.resolveMiddleware controller, action
        @_resolveControllerAction controller, action
      when 'object'
        {controller, action} = cb
        #console.log controller
        #MiddlewareDefinition.resolveMiddleware controller, action
        @_resolveControllerAction controller, action
      else
        throw new Error("unknown route endpoint #{@cb}")

  # Route `method`, `path`, and optional middleware
  # to the callback defined by `cb`.
  # 
  # @param {String} method
  # @param {String} path
  # @param {Function} ...
  # @param {Function|String|Object} cb - connect middlewares or middleware definition as defined by `DefinitionResolver` class
  # @return {Router} for chaining
  # @api private
  
  _route: (method, path) ->
    definition = arguments[arguments.length - 1]
    return super if arguments.length < 3 or typeof definition != 'object' # just like old api
    {to, as} = definition
    return super if typeof to == 'undefined' # just like old api
    fn = switch typeof to
      when 'function'
        Controller.middleware to
      when 'string'
        throw new Error("string route definition must be in the form 'controller#action'") unless to.match /[\w_]+#[\w_]+/
        [controller, action] = to.split '#'
        # todo if controller index
        throw new Error("string route definition must be in the form 'controller#action'") if controller is undefined
        @_resolveControllerAction controller, action
      when 'object'
        {controller, action} = to
        @_resolveControllerAction controller, action
      else
        throw new Error("unknown route endpoint #{to}")
    super method, path, fn


  # Validates the existence of controller and returns the resolved middleware
  # 
  # @param {String} controller - the controller name
  # @param {String} action - the controller action (or skip if rest)
  # @return {Function} a Connect middleware (that resolves to the given controller and action)
  # @api private
  _resolveControllerAction: (controller, action) ->
    throw new Error("cannot resolve controller") unless controller?
    action = 'index' unless action?
    @findController(controller).middleware action


  # Requires the given controller based on the "controllers path" configuration
  #
  # @param {String} controller - the controller name
  # @return {Object} the controller class
  # @api public
  findController: (controller) ->
    controllersPath = @app.set 'controllers path'
    throw new Error("please configure controllers path") unless controllersPath?
    require "#{controllersPath}/#{controller}"
  
  
  # Return a url given a controller and an action, and optional params
  # TODO: steal from https://github.com/josh/rack-mount/blob/master/lib/rack/mount/route_set.rb
  #
  #     Given a route "/users/:id"
  #
  #     @url controller: 'users', id: 10, page: 12
  #     /users/10?page=12
  #
  url: (opts) ->
    throw new Error('controller must be specified') unless opts.controller?
    controller = opts.controller
    action = opts.action || 'index'
    method = opts.action || 'get'

###

# Monkey patch express-resource #route to autoload rest controller actions
#
#     class Users extends Controller
#       @action index: -> @render 'index'
#       ...
#
#     @resource 'users'
#
#@name {string} the controller name
#@api public
resource = express.HTTPServer.prototype.resource
express.HTTPServer.prototype.resource =
express.HTTPSServer.prototype.resource = (name, controllerName) -> # TODO: collection, member
  controller = MiddlewareDefinition.findController controllerName
  #resource.call @, name, controller.middlewares()
  resource.call resource.app, name, controller.middlewares()
###

module.exports = Router

