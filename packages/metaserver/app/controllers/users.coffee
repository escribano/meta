#Controller = require '../../lib/base/controller'
{Controller} = require '../../lib/base'
User = require '../models/user'


class Users extends Controller
  
  @scaffold User


module.exports = Users