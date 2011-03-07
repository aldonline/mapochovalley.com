# helpers
_user = (user) ->
  div class:'user', ->
    a href: "/profile/#{user.uid}", title: user.name, ->
      img src: "http://graph.facebook.com/#{user.uid}/picture"

# HTML output
coffeescript -> require('./index').init()

div class:'container-left', ->
  div class:'logo-steps-container', ->
    div class:'logo', ->
      a href:'/', ->
        img 
          src:'/assets/mapochovalley-home.png'
          width:360
          height:140
          border:0

    div class:'steps', ->
      ol ->
        li 'Log in with your Facebook account'
        li 'Get your badge'
        li 'Customize your badge'

  div class:'box-container', ->
    div class:"headline", ->
      h1 'Welcome to Mapocho Valley'
      h5 "Mapocho Valley is a physical and virtual convergence point for the emerging high tech community in Santiago Chile."
      p "We are a club that spans across universities, organizations and the private sector. Being part of this club is a statement:
        You are, or want to be, a Global Entrepreneur."
      p "For now, we can tell you that , during our initial phase we will host and support meetups, parties and events. We will also provide guidance, coaching, contacts and infrastructure to anyone who is interested in promoting a High Tech Entrepreneurial lifestyle and networking in Santiago Chile through social events and activities. Our web infrastructure is under construction and you will see some of it soon."
    
  # text "<script> require('./common').render_twitter_widget() </script>"
  # iframe width:225, height:570, src:'http://meetu.ps/yjFp', frameborder:0

div class:'container-right', ->
  div class:'users', ->
    p "People registered in Mapocho Valley:"
    _user user for user in @users
