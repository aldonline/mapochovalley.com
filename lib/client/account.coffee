
_form = null
get_form = -> _form ?= $ '#edit-account-form'
set_busy = ( flag ) -> get_form().css opacity: if flag then .5 else 1
reload_badge_image = ->
  img = $('#badge-img')
  src = img.attr 'src'
  src.split('?')[0] + '?' + (new Date).getTime()
  img.attr src:src

exports.init = ->
  $ ->
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
  console.log 'saving data...'
  data = extract()
  set_busy yes
  ___minirpc.set_badge_data data, (err, res) ->
    console.log ['saved data', err, res]
    fetch_data()
    reload_badge_image()

bools = 'is_investor,is_entrepreneur,is_developer,is_sup'.split ','

inject = (obj) ->
  for name in bools
    c = $('#'+name)
    if obj[name] is true then c.attr('checked','checked') else c.removeAttr 'checked'
  $('#email').val obj.email
  $('#tagline').val obj.tagline
  $('#twitter_id').val obj.twitter_id

extract = ->
  obj = {}
  for name in bools
    obj[name] = $('#'+name).attr 'checked'
  obj.email = $('#email').val()
  obj.tagline = $('#tagline').val()
  obj.twitter_id = $('#twitter_id').val()
  obj

