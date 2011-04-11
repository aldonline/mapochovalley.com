model = require './model'

###
The shell exposes persistent model mutators and accessors
but acts on behalf of a given user.
it enforces ACLs
###
class Shell
  constructor: (@uid, @access_token) ->

  # gets the current user's data from Mongo DB
  get_badge_data : ( cb ) ->
    model.get_person @uid, (err, res) =>
      # filter which properties we send over the wire
      delete res.email
      cb null, res

  # updates the current user's data
  set_badge_data : ( data, cb ) ->
    model.get_person @uid, (err, person) =>
      person.badge_name = data.badge_name or person.name
      person.tagline = data.tagline
      person.twitter_id = data.twitter_id
      person.tags = data.tags or []
      person.save ->
        cb null, true
  
  @for_request : (req) ->
    req.mvshell ?= if ( c = req.fbx_cookie )? then new Shell c.uid, c.access_token else null

module.exports = Shell