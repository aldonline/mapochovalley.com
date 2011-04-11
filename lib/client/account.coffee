icon_selector = require './icon_selector'

ics = null

_form = null
get_form = -> _form ?= $ '#edit-account-form'
set_busy = ( flag ) -> get_form().css opacity: if flag then .5 else 1
reload_badge_image = ->
  img = $('#badge-img')
  src = img.attr 'src'
  img.attr src: src.split('?')[0] + '?' + (new Date).getTime()
  img.hide().fadeIn()

exports.init = ->
  $ ->
    ___minirpc.get_icon_map (res) ->
      ics = new icon_selector.IconSelector $('#icon-selector-container'), res
      $('#account-table').find('p:even').css 'background-color':'#eee'
    form = get_form()
    # form.validate()
    fetch_data()
    $('#save-account-button').click ->
      save_data()
      false

fetch_data = ->
  set_busy yes
  console.log 'fetching data...'
  ___minirpc.get_badge_data (err, res) ->
    console.log ['got data', res]
    if err?
      throw new Error 'rpc.get_badge_data error:' + err
    inject res
    set_busy no

save_data = ->
  data = extract()
  console.log [ 'saving data...', data ]
  set_busy yes
  ___minirpc.set_badge_data data, (err, res) ->
    console.log ['saved data', err, res]
    fetch_data()
    reload_badge_image()

inject = (obj) ->
  ics.set_values obj.tags or []
  $('#tagline').val obj.tagline
  $('#twitter_id').val obj.twitter_id
  $('#badge_name').val obj.badge_name

extract = ->
  obj = {}
  obj.tags = ics.get_values()
  obj.tagline = $('#tagline').val()
  obj.twitter_id = $('#twitter_id').val()
  obj.badge_name = $('#badge_name').val()
  obj

