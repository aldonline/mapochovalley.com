class IconSelector
  constructor: (@container, @icon_map) ->
    c = @container
    @cbxs = {}
    for icon in @icon_map
      img = $('<img>').attr src:'/icons/' + icon.url
      img.css height: 20, width: 20
      
      input_id = 'cbx_' + icon.id # id is only used to link to <label>
      
      p = $('<p>')
      label = $('<label>').attr( 'for':input_id ).text icon.label
      input = $('<input>').attr type:'checkbox', id:input_id
      
      @cbxs[icon.id] = input
      
      p.append img
      p.append input
      p.append label
      
      c.append p
      # we now have all checkboxes in the @cbxs object
  
  set_values : ( values ) ->
    # wipe all
    cbx.attr('checked', no) for k, cbx of @cbxs
    # then set some
    if values?
      @cbxs[v].attr('checked', yes ) for v in values
  
  get_values : ->
    k for own k, cbx of @cbxs when cbx.attr 'checked'

exports.IconSelector = IconSelector