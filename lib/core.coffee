request = require 'request'
querystring = require 'querystring'
minirpc = require 'minirpc'
connect = require 'connect'
browserify = require 'browserify'
jsmin = require 'jsmin'
model = require 'mv_server_model'
facebook_express = require 'facebook-express'


fbx = facebook_express.create_app
  app_id: ''
  app_secret: ''

class MVShell
  constructor: (@uid, @access_token) ->
  # gets the current user's data from Mongo DB
  get_badge_data : ( cb ) ->
    model.Person.find uid:@uid, (err, res) =>
      cb null, res[0]
  set_badge_data : ( data, cb ) ->
  @for_request : (req) ->
    req.mvshell ?= if ( c = req.fbx_cookie )? then new MVShell c.uid, c.access_token else null

# create an RPC proxy so we can call server side code from the client
rpc = new minirpc.RPC
rpc.get_badge_data = -> (cb) ->
  s = MVShell.for_request rpc._request
  if s? then s.get_badge_data cb else cb 'not authorized'
rpc.set_badge_data = -> ( data, cb) ->
  s = rpc._request.mvshell?
  if s? then s.set_badge_data data, cb else cb 'not authorized'

set_middleware_on_server = (server) ->
  # zappa sets bodyDecoder, cookieDecoder and session
  fbx.init server
  server.use rpc._middleware()
  ###
  server.use browserify 
    mount : '/___client.js'
    base: __dirname
    require: ['mv_client']
  ###

MV = 
  set_middleware_on_server : set_middleware_on_server
  set_on_this: (t) -> t.MV = MV

MV.fbapi = fbx.api

exports.MV = MV