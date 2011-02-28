facebook_express = require 'facebook-express'
config = require './config'

fbx = facebook_express.create_app
  app_id: config.app_id
  app_secret: config.app_secret

module.exports = fbx