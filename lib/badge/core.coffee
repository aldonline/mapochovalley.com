util = require 'util'
express = require 'express'
generator = require './generator'
model = require '../model'
icon_map = require './icon_map'
config = require '../config'

###
serves badge images for each person
they will be accessible at the following URI
###

# returns the URL for an icon by reading the icon_map
# If the icon does not exist, it returns undefined
get_icon_url = (id) -> return icon.url for icon in icon_map when icon.id is id

exports.init = ( server ) ->
  server.get '/badge/:id.png', (req, res) ->
    id = req.params.id
    model.get_person id, (err, person) ->
      if person?
        url = config.url + '/profile/' + person.uid
        name = person.badge_name or person.name
        twt = person.twitter_id
        icons = (get_icon_url id for id in person.tags)
        # filter out undefined and nulls
        # ( may happen if user has a tag that has no icon in icon_map )
        icons = (icon for icon in icons when icon?) 
        canvas = generator.generate_badge_canvas url, name, twt, person.tagline, '', icons
        generator.respond_canvas_as_png canvas, res
      else # TODO: handle 500
        res.statusCode = 404
        res.send 'badge not found'
  
  # to serve independent icons to the UI for preview
  server.use '/icons', express.static __dirname + '/icons'
  
  # used during development
  server.get '/badgetest.png', (req, res) ->
    url = config.url + '/profile/test'
    icons = ['startupchile.png', 'symbolize/coffee.png', 'symbolize/email.png']
    canvas = generator.generate_badge_canvas url, 'Aldo Bucchi C', '@aldonline', 'I am super cool', 'ES EN', icons
    generator.respond_canvas_as_png canvas, res