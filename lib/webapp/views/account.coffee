
# Helpers

cbx = (_label, _id, _checked=false) ->
  attrs = type:'checkbox', id:_id
  if _checked 
    attrs.checked = "checked"
  p ->
    label _label
    input attrs

# HTML output

coffeescript -> require('./account').init()

table id:'account-table', ->
  tr ->
    td class:'td1', ->
      form id:'edit-account-form', ->
        p -> 
          label 'Name on Badge', 'for':'tagline'
          input id:'badge_name', type:'text' , class:'required'
        p -> 
          label 'Tagline', 'for':'tagline'
          input id:'tagline', type:'text' , class:'required'
        p ->
          label 'Twitter ID', 'for':'twitter_id'
          input id:'twitter_id', type:'text'
    td class:'td2', ->
      div class:'badge', ->
        img id:'badge-img', src: '/badge/' + @user.uid + '.png', width: 300
      center ->
        button id:'save-account-button', -> 'Apply Changes'
    td class:'td3', ->
      div id:'icon-selector-container', ->