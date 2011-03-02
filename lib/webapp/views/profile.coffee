
cbx = (_label, _id) ->
  p ->
    label _label + ':'
    input type:'checkbox', id:_id

# form
# we define the structure here, but it will be manipulated on the client side
# see mv_client_badge.coffee
form id:'edit-badge-form', style:'display:none', ->
  cbx 'Investor', 'i_is_investor'
  cbx 'Entrepreneur', 'i_is_entrepreneur'
  cbx 'Developer', 'i_is_developer'
  cbx 'Start-Up Chile Entrepreneur', 'i_is_sup'
  p ->
    label 'Tagline:', 'for':'i_tagline'
    input id:'i_tagline', type:'text' , class:'required'
    br()
    text 'A simple text saying this and that'
  p ->
    label 'Email:', 'for':'i_email'
    input id:'i_email', type:'text' , class:'required email'
  p ->
    label 'Twitter ID:', 'for':'i_twitter_id'
    input id:'i_twitter_id', type:'text'
    text '@aldonline'

button id:'edit-profile-button', -> 'Edit'
a href:'/', ->
  img src:'/assets/mapochovalley-home.png', style:'width:360px; height:140px; border:0'
div style: 'width: 980px; position:relative', ->
  img src: '/badge/' + @user.id + '.png', width: 200
  div style:'margin-left:400px ; border: 1px solid #ccc', ->
    img src: @user.pic_url, style:'display:block'
    a href:@user.link, -> 'Facebook Profile'
  text "<script> require('./common').render_twitter_widget( '#{@user.twitter}' ) </script>" if @user.twitter?