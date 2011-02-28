require.paths.unshift 'js-src'

querystring = require 'querystring'

MV = require('MV').MV

# setup http server with required middleware
mv = app 'Mapocho Valley'
MV.set_middleware_on_server mv.http_server

# this is a trick to enable globals in controllers, views, etc
def MV: MV

fbapi = MV.fbapi

class User
  constructor : (@id) ->
    @mv_url = "http://dev.mapochovalley.com/#{@id}"
    @pic_url = "http://graph.facebook.com/#{@id}/picture?type=large"
  add_fb_object : (obj) -> ( this[k] = v ) for k, v of obj

# methods
get_user = (id, cb) ->
  fbapi "/#{id}", (res) ->
    user = new User id
    user.add_fb_object res
    cb user
def get_user:get_user

get_group_members = (cb) ->
  cb []
  fbapi "/#{MV.fb_group_id}/members", (res) -> cb res.data
def get_group_members:get_group_members

include 'controllers.coffee'
include 'views.coffee'