util = require 'util'
express = require 'express'

generator = require './generator'
model = require '../model'

###
serves badge images for each person
they will be accessible at the following URI
###

exports.init = ( server ) ->
  server.get '/badge/:id.png', (req, res) ->
    id = req.params.id
    model.get_person id, (err, person) ->
      if person?
        url = 'http://mapochovalley.com/profile/'+person.uid
        canvas = generator.generate_badge_canvas url, person.badge_name or person.name, person.twitter_id, person.tagline, ''
        generator.respond_canvas_as_png canvas, res
      else # TODO: handle 500
        res.statusCode = 404
        res.send 'badge not found'
  
  # to serve independent icons to the UI for preview
  server.use '/icons', express.staticProvider __dirname + '/icons'
  
  # used during development
  server.get '/badgetest.png', (req, res) ->
    url = 'http://mapochovalley.com/profile/test'
    icons = ['startupchile.png', 'symbolize/coffee.png', 'symbolize/email.png']
    canvas = generator.generate_badge_canvas url, 'Aldo Bucchi C', '@aldonline', 'I am super cool', 'ES EN', icons
    generator.respond_canvas_as_png canvas, res