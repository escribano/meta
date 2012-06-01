scaffoldViews = __dirname + '/views'


# The scaffold macro
#  
#     class Tweets extends Controller
#       @scaffold (conf) ->
#         conf.actions = ['index', 'create']
#         conf.columns = ['id', 'name', 'role]
#
# @mode {Object} the model to be scaffolded
# @config {Function}
# @api public
scaffold = (model, config) ->

  @action index: ->
    model.find (@err, @items) => @render 'index'
  
  @action create: ->
    @item = new model() @param 'record'
    @item.save (@err) => @redirect 'back'
  
  # add our scaffold views as fallbacks
  render = @::render
  @::render = (template, fn) -> 
    try
      render.call @, template, fn
    catch e # TODO: limit template not found
      oldViews = @res.app.set 'views'
      @res.app.set 'views', scaffoldViews
      render.call @, template, fn
    finally
      @res.app.set 'views', oldViews if oldViews?


# augment Controllers with scaffolding
Controller = require '../base/controller'
Controller.scaffold = scaffold


exports.scaffold = scaffold
