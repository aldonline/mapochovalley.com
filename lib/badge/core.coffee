util = require 'util'

generator = require './generator'
model = require '../model'

###
serves badge images for each person
they will be accessible at the following URI
###

exports.init = ( server ) ->
  server.get '/badge/:id.png', (req, res) ->
    id = req.params.id
    model.Person.findOne uid:id, (err, person) ->
      if person?
        canvas = generator.generate_badge_canvas 'http://mapochovalley.com/profile/'+person.uid, person.badge_name, person.twitter_id, person.tagline
        generator.respond_canvas_as_png canvas, res
      else # TODO: handle 500
        res.statusCode = 404
        res.send 'badge not found'