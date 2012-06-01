jade = require 'jade'


# Creates helper functions to be used in templates
# 
#     # helpers.coffee
#     exports.flashes = helper ->
#       div class: "flashes", ->
#         for name, content of @flash
#           div class: name, -> content
#
#     # view.jade
#     div #{flashes()}
# 
# @param {Function} fn - function to be made available as a helper
# @return {Function) a function that can be used as a helper in jade views
# @api public
exports.helper = (fn) ->
  -> 
    jade.compile(fn)(@)
    options = {}
    options.pretty = true
    options.filename = filename
    fnjade = jade.compile(str,options)
    fnjade = jade.compile str,
      filename: filename
      pretty: true
      compileDebug: false
    #callback null, fnjade()
    fnjade()