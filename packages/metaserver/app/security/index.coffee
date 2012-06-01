exports.level = (role) ->
  (req, res, next) ->
    #(if req.authenticatedUser.role is role then next() else next(new Error("Unauthorized")))
    if role == 'owner'
      return next()
    else 
      return next new Error("Unauthorized")
      
exports.oldlevel = (role) ->
  (req, res, next) ->
    #(if req.authenticatedUser.role is role then next() else next(new Error("Unauthorized")))
    if role == 'owner'
      return next()
    else 
      return next new Error("Unauthorized")