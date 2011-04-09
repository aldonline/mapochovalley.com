express = require 'express'
coffeekup = require 'coffeekup'
browserify = require 'browserify'


badge = require '../badge/core'
config = require '../config'
strings = require '../strings'
rpc = require '../rpc'
model = require '../model'

fbx = model.fbx

port = config.port or 80

console.log ''
console.log 'Started Mapocho Valley Web App with the following Configuration:'
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
  model.Person.find (err, user_list) -> 
    context =
      config : config
      strings : strings
      show_fb_login_button : yes
      show_edit_account_button : req.fbx_cookie?
      og_title : strings.title
      og_description : strings.description
      og_image : '/assets/mapochovalley-home.png'
      users: user_list
    res.render 'index', context: context

server.get '/profile/:id', (req, res) ->
  model.Person.findOne uid:req.params.id, (err, user) ->
    context =
      config : config
      strings : strings
      title : user.name
      user : user
      show_fb_login_button : yes
      show_edit_account_button : req.fbx_cookie?
      og_title : "#{user.name}'s profile @ #{strings.title}"
      og_description : "#{user.name}'s profile @ #{strings.title}"
      # could use a more personalized image here. good for FB share
      # this image can be built using HTML5 Canvas. See ./badge/generator module
      og_image : '/assets/mapochovalley-home.png'
    res.render 'profile', context: context

server.get '/register', (req, res) ->
  # if user is already logged in, redirect to profile
  if req.fbx_cookie?
    res.writeHead 302, Location: '/profile/' + c.uid
    res.end()
    return
  context = 
    config : config
    fbx : fbx
    strings : strings
    show_fb_login_button : no
    show_edit_account_button : no
    og_title : 'Register @ ' + strings.title
    og_description : strings.description
    og_image : '/assets/mapochovalley-home.png'
  res.render 'register', context: context

server.get '/account', (req, res) ->
  if not uid = req?.fbx_cookie?.uid
    res.send 'Not Authorized', 501
    return
  model.Person.findOne uid:uid, (err, user) ->
    context =
      show_fb_login_button : yes
      show_edit_account_button : no 
      config : config
      strings : strings
      title : user.name
      user : user
      uid : req.fbx_cookie?.uid
    res.render 'account', context: context

server.listen port
console.log 'Mapocho Valley App listening on port ' + port
