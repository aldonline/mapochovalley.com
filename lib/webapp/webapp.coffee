express = require 'express'
coffeekup = require 'coffeekup'
browserify = require 'browserify'
facebook_express = require 'facebook-express'


fbx = require '../fbx'
badge = require '../badge/core'
config = require '../config'
strings = require '../strings'
rpc = require '../rpc'
model = require '../model'

port = config.port or 80

console.log ''
console.log 'Load Mapocho Valley Web App with the following Configuration:'
console.log JSON.stringify config

## --- create and configure server

server = express.createServer()

server.register '.coffee', coffeekup
server.set 'view engine', 'coffee'

fbx.init server
badge.init server
rpc._init server

pub = __dirname + '/public'
server.use express.compiler src: pub, enable: ['less']
server.use express.staticProvider pub
# the following middleware is the defacto standard
# but we are not using it (yet), so I comment out
# server.use express.bodyDecoder()
# server.use express.cookieDecoder()
# TODO: Make the secret configurable.
# server.use express.session secret: 'hackme'

# make scripts located in lib/client available to the client
server.use browserify base : __dirname + '/../client', mount : '/client.js'

server.get '/', (req, res) ->
  context = 
    strings : strings
    show_fb_login_button : yes
    og_title : strings.title
    og_description : strings.description
    og_image : '/assets/mapochovalley-home.png'
  res.render 'index', context: context

server.get '/profile/:id', (req, res) ->
  model.get_user req.params.id, (user) =>
    context = 
      strings : strings
      title : user.name
      user : user
      show_fb_login_button : yes
      og_title : "#{user.name}'s profile @ #{strings.title}"
      og_description : "#{user.name}'s profile @ #{strings.title}"
      # could use a more personalized image here. good for FB share
      og_image : '/assets/mapochovalley-home.png'
    res.render 'profile', context: context

server.get '/register', (req, res) ->
  if  (c = req.session?.fbx_cookie )?
    res.writeHead 302, Location: '/profile/' + c.uid
    res.end()
  context = 
    config : config
    strings : strings
    show_fb_login_button : no
    og_title : 'Register @ ' + strings.title
    og_description : strings.description
    og_image : '/assets/mapochovalley-home.png'
  res.render 'register', context: context

server.listen port
console.log 'Mapocho Valley App listening on port ' + port
