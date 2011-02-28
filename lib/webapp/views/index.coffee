a href:'/', ->
  img src:'/assets/mapochovalley-home.png', style:'width:720; height:280; border:0'
hr()
###
for member in @members
  a href:"/badge/#{member.id}", title:member.name, ->
    img src:"http://graph.facebook.com/#{member.id}/picture"
###
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
text "<script> require('mv_client').render_twitter_widget() </script>"
# iframe width:225, height:570, src:'http://meetu.ps/yjFp', frameborder:0