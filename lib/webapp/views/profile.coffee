# HTML output

coffeescript -> require('./profile').init()

div class:'container-left', ->
  div class:'logo', ->
    a href:'/', ->
      img 
        src:'/assets/mapochovalley-home.png'
        width:360
        height:140
        border:0
    p '''
      Your Mapocho Valley account is connected to your Facebook Profile.
      Most of the data comes from Facebook.
    '''

  div class:'facebook-profile', ->
    p class:'title', -> @user.name
    a href:'#', -> img src: "http://graph.facebook.com/#{@user.uid}/picture?type=large"
    a href:"http://facebook.com/profile.php&id=#{@user.uid}", target:"_blank", -> p 'Go to Facebook Profile'

div class:'container-right', ->
  div class:'badge', ->
    p "Your badge:"
    img src: '/badge/' + @user.uid + '.png', width: 200 
    div style:'margin-left:400px ; border: 1px solid #ccc', ->
    a href:"/badge/#{@user.uid}/print", -> "Print"