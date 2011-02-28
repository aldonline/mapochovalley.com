model = require './model'

class Shell
  constructor: (@uid, @access_token) ->
  # gets the current user's data from Mongo DB
  get_badge_data : ( cb ) ->
    model.Person.find uid:@uid, (err, res) =>
      cb null, res[0]
  set_badge_data : ( data, cb ) ->
  @for_request : (req) ->
    req.mvshell ?= if ( c = req.fbx_cookie )? then new Shell c.uid, c.access_token else null

module.exports = Shell