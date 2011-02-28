mv_client = require 'mv_client'

###
status
  dialog closed
  dialog open, fetching data
  data fetched, editing
  saving
###

$ -> $('#edit-profile-button').click -> edit_badge()

open_modal = (content) ->
  di = $('<div>')
  di.append content
  di.appendTo $ 'body'
  di.dialog
    autoOpen:true
    title: 'Update your Profile'
    modal:true
    height: 450
    width: 700
    buttons:
      "Save!": ->
        console.log 'Saving Data'
      Cancel: ->
        $(@).dialog 'close'
    close: ->

edit_badge = (data) ->
  container = $ '<div>'
  open_modal container
  container.text 'Loading...'
  ___minirpc.get_badge_data (err, res) ->
    container.text ''
    form = get_form()
    container.append form
    form.css display:'block'
    form.validate()
    inject res
    # load data into form

_form = null
get_form = -> _form ?= $ '#edit-badge-form'

bools = 'is_investor,is_entrepreneur,is_developer,is_sup'.split ','

inject = (obj) ->
  for name in bools
    c = $('#i_'+name)
    if obj[name] is true then c.attr('checked','checked') else c.removeAttr 'checked'
  $('#i_email').val obj.email

extract = ->
  for name in bools
    obj[name] = $('#i_'+name).attr('checked') is checked
  obj.email = $('#i_email').val()


