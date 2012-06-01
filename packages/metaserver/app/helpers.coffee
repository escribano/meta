{helper} = require '../lib/base/view'


# Put helpers here


# A helper to render flash messages
# 
#     # view.coffee
#     div -> @flashes()
# 
# @api public
exports.flashes = helper ->
  div class: "flashes", ->
    for name, content of @flash
      div class: name, -> content