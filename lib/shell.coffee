model = require './model'

###
The shell exposes persistent model mutators
but acts on behalf of a given user.
it enforces ACLs
###
class Shell
  constructor: (@uid, @access_token) ->

  # gets the current user's data from Mongo DB
  get_badge_data : ( cb ) ->
    model.Person.findOne uid:@uid, (err, res) =>
      # TODO: filter which properties we send over the wire
      cb null, res

  # updates the current user's data
  set_badge_data : ( data, cb ) ->
    model.Person.findOne uid:@uid, (err, person) =>
      person.email = data.email
      person.tagline = data.tagline
      person.is_entrepreneur = data.is_entrepreneur
      person.is_investor = data.is_investor
      person.is_developer = data.is_developer
      person.is_sup = data.is_sup
      person.save ->
        cb null, true
    
  @for_request : (req) ->
    req.mvshell ?= if ( c = req.fbx_cookie )? then new Shell c.uid, c.access_token else null

module.exports = Shell