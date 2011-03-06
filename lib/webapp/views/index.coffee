# helpers
_user = (user) ->
  a href: "/profile/#{user.uid}", title: user.name, ->
    img src: "http://graph.facebook.com/#{user.uid}/picture"

# HTML output
coffeescript -> require('./index').init()

a href:'/', ->
  img src:'/assets/mapochovalley-home.png', style:'width:720; height:280; border:0'
hr()
_user user for user in @users
hr()
h1 'Welcome to Mapocho Valley'
text @strings.description
p ->
  'Get your badge!'
p ->
  '1. Log in with your Facebook account'
p ->
  '2. Customize your badge'
p ->
  '3. Done ;)'
text "<script> require('./common').render_twitter_widget() </script>"
# iframe width:225, height:570, src:'http://meetu.ps/yjFp', frameborder:0