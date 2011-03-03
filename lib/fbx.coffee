facebook_express = require 'facebook-express'
config = require './config'

# we create the facebook helper here, not on the main webapp module
# because it is depended upon by other modules as well. ( i.e. model )

fbx = facebook_express.create_helper
  app_id: config.app_id
  app_secret: config.app_secret
  domain: config.domain
  registration:
    fields: [
      {name:'name'}
      {name:'email'}
    ]
  on_registration: ( data, cb ) ->
    console.log 'Got registration data.'
    console.log 'For now we are just logging this, but we should store it into mongo'
    console.log data
    cb 'http://mapochovalley.com/'

module.exports = fbx