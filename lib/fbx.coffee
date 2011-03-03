facebook_express = require 'facebook-express'
config = require './config'

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
    console.log 'Got registration data. it was really easy.'
    console.log data
    cb 'http://mapochovalley.com/'

module.exports = fbx