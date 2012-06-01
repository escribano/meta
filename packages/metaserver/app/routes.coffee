{level} = require "./security"

module.exports = ->

  ##@use (req, res, next) ->
  ##  res.render "index"

  # Can use function callbacks that run inside of a controller context
  @get '/', to: ->
    @title = "Hello route function!"
    #@layout = false
    #@layout = "layouts/application"
    @render 'index'

  # Can use controller actions callbacks
  @get '/tweets', [level 'owner' ], to: {controller: 'tweets', action: 'index'}
  #@get '/:view', [level 'owner'], to controller: 'samples/sample-controller', action: 'view'
  #@get '/tweets', to: 'tweets#index', as: 'tweets'
  #@get '/tweets', 
  #@get '/tweets', [level( 'owner')], to: {controller: 'tweets'}
  #@get '/twats', level 'owner', to: {controller: 'tweets'}, us: 'twitas'

  @post '/tweets', to: {controller: 'tweets', action: 'create'}, as: 'create_tweet'
  
  @get '/admin/tweets', to: 'admin/tweets#index', as: 'admin_tweets'
  
  # Namespaces
  @namespace '/admin', ->
    # Can use REST routing via express-resource
    # Users controller also uses scaffold in this example
    @resource 'users' # admin_users_create
    
    @get '/test', to: ->
      @title = "Hello namespace!"
      @render 'index'
