
# Helpers

cbx = (_label, _id, _checked=false) ->
  attrs = type:'checkbox', id:_id
  if _checked 
    attrs.checked = "checked"
  p ->
    label _label + ':'
    input attrs

# HTML output

coffeescript -> require('./profile').init()

# form
# we define the structure here, but it will be manipulated on the client side
# see mv_client_badge.coffee

div class:'container-left', ->
  div class:'logo', ->
    a href:'/', ->
      img 
        src:'/assets/mapochovalley-home.png'
        width:360
        height:140
        border:0
    p "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

  div class:'facebook-profile', ->
    p class:'title', -> "Update your profile data:"
    a href:'#', -> img src: "http://graph.facebook.com/#{@user.uid}/picture?type=large"
    a href:"http://facebook.com/profile.php&id=#{@user.uid}", target:"_blank", -> p @user.name
    form id:'edit-badge-form', action:"/profile/#{@user.uid}/update", method:'post', ->
      cbx 'Investor', 'is_investor', @user.is_investor?
      cbx 'Entrepreneur', 'is_entrepreneur', @user.is_entrepreneur?
      cbx 'Developer', 'is_developer', @user.is_developer?
      cbx 'Start-Up Chile Entrepreneur', 'is_sup', @is_sup?
      p ->
        label 'Tagline:', 'for':'tagline'
        input id:'tagline', type:'text' , class:'required', value:@user.tagline or= ''
      p ->
        label 'Email:', 'for':'email'
        input id:'email', type:'text' , class:'required email', value:@user.email or= ''
      p ->
        label 'Twitter ID:', 'for':'twitter_id'
        input id:'twitter_id', type:'text', value:@user.twitter or= ''
      
      button id:'update-profile-button', -> 'Update'
        
div class:'container-right', ->
  div class:'badge', ->
    p "Your badge:"
    img src: '/badge/' + @user.uid + '.png', width: 200 
    div style:'margin-left:400px ; border: 1px solid #ccc', ->
    a href:"/badge/#{@user.uid}/print", -> "Print"
    
  # text "<script> require('./common').render_twitter_widget() </script>"
  # iframe width:225, height:570, src:'http://meetu.ps/yjFp', frameborder:0
