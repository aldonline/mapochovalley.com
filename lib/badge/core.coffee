generator = require './generator'
util = require 'util'

###
serves badge images for each person
they will be accessible at the following URI
###

exports.init = ( server ) ->
  server.get '/badge/:id.png', (req, res) ->
    canvas = generator.generate_badge_canvas 'http://mapochovalley.com/badge/4343', 'Aldo Bucchi ' + req.params.id, '@aldonline', 'Foo!'
    generator.respond_canvas_as_png canvas, res