strings = require '../strings'
express = require 'express'
coffeekup = require 'coffeekup'
browserify = require 'browserify'

try
  config = require '../../localconfig'
catch error
  console.log strings.err_localconfig_is_missing
  return

config = config.get_config()
port = config.port or 80

console.log ''
console.log 'Load Mapocho Valley Web App with the following Configuration:'
console.log JSON.stringify config


server = express.createServer()

server.register '.coffee', coffeekup
server.set 'view engine', 'coffee'

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
    requires : ['mv_client_util', 'mv_client', 'mv_client_home', 'mv_common']
    og_title : 'some title' # MV.title
    og_description : 'some description' # MV.description
    og_image : '/assets/mapochovalley-home.png'
  res.render 'index', context: context


server.listen port
console.log 'Mapocho Valley App listening on port ' + port








###

get '/': ->
  MV.set_on_this @
  @show_fb_login_button = yes
  @requires = ['mv_client_util', 'mv_client', 'mv_client_home', 'mv_common']
  console.log 'before get members'
  get_group_members (members) =>
    console.log 'got members'
    @members = members
    @og_title = MV.title
    @og_description = MV.description
    @og_image = '/assets/mapochovalley-home.png'
    render 'index'

get '/register': ->
  if  (c = request.session?.fb_cookie )?
    response.writeHead 302, Location: '/badge/' + c.uid
    response.end()
  MV.set_on_this @
  @requires = ['mv_client_util', 'mv_client', 'mv_common']
  render 'register'

get '/badge/:id' : ->
  @show_fb_login_button = yes
  MV.set_on_this @
  @requires = ['mv_client_util', 'mv_client', 'mv_client_badge', 'mv_common']  
  get_user @id, (user) =>
    @title = user.name
    @user = user
    @og_title = "#{user.name}'s profile @ #{MV.title}"
    render 'badge'

###