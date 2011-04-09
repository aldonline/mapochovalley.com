# HTML output

coffeescript -> require('./profile').init()

fb_url = "http://facebook.com/profile.php?id=#{@user.uid}"

center ->
  p class:'username', -> @user.name

div class:'container container-left', ->
  a href:fb_url, target: '_blank', ->
    img src: "http://graph.facebook.com/#{@user.uid}/picture?type=large"
  p style:'width: 200px; margin-left: auto;', ->
    text 'To view more information about this member, go to '
    a href:fb_url, -> 'Facebook'
    br()
    br()
    a href:'/#faq-why-so-simple', -> ' ( why? )'

badge_url = '/badge/' + @user.uid + '.png'

div class:'container container-right', ->
  div class:'badge', ->
    a href: badge_url, ->
      img src: badge_url, width: 300
  a href: badge_url, -> 'Print this Badge'
  p -> '( If you print at 300dpi it will fit in a badge holder )'