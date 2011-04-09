# helpers
_user = (user) ->
  a href: "/profile/#{user.uid}", title: user.name, ->
    img src: "http://graph.facebook.com/#{user.uid}/picture"

# HTML output
coffeescript -> require('./index').init()

div class:'users', ->
  _user user for user in @users
