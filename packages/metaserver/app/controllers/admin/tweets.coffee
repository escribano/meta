#Controller = require '../../../lib/base/controller'
{Controller} = require '../../../lib/base'
Tweet = require '../../models/tweet'


class Tweets extends Controller
  
  @action index: ->
    Tweet.find (@err, @tweets) => @render 'index'


module.exports = Tweets