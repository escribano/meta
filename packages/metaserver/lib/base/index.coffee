express = require 'express'
require 'express-resource'
require 'express-namespace'
HTTPServer = require './http'
HTTPSServer = require './https'
I18n = require './i18n'
Controller = require './controller'


# Shortcut for `new Server(...)`.
#
# @param {Function} ...
# @return {Server}
# @api public
createServer = (options) ->
  if 'object' == typeof options
    new HTTPSServer options, Array.prototype.slice.call(arguments, 1)
  else
    new HTTPServer Array.prototype.slice.call(arguments)


    exports.createServer = function(options){
      if ('object' == typeof options) {
        return new HTTPSServer(options, Array.prototype.slice.call(arguments, 1));
      } else {
        return new HTTPServer(Array.prototype.slice.call(arguments));
      }
    };

exports.createServer = createServer
exports.HTTPServer = HTTPServer
exports.HTTPSServer = HTTPSServer
exports.I18n = I18n
exports.Controller = Controller
exports.express = express
