# HTML output

coffeescript -> require('./profile').init()

center ->
  p class:'username', -> @user.name

div class:'container container-left', ->
  a href:'#', -> img src: "http://graph.facebook.com/#{@user.uid}/picture?type=large"
  a href:"http://facebook.com/profile.php&id=#{@user.uid}", target:"_blank", -> div 'Go to Facebook Profile'

div class:'container container-right', ->
  div class:'badge', ->
    img src: '/badge/' + @user.uid + '.png', width: 300 