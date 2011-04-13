assert = require 'assert'

shortcuts = 
  c: 'cardinality'
  p: 'path'
  t: 'type'
  v: 'validator'
  g: 'getter'
  s: 'setter'
unshortcut = (k) -> if ( c=shortcuts[k] )? then c else k

array_box = (v) ->
  return [] unless v?
  return [v] unless v instanceof Array
  v

array_unbox = (v, strict) ->
  return null unless v?
  if v instanceof Array
    if v.length is 0
      return null
    if v.length isnt 1 and strict
       throw new Error 'unboxing array with length > 1'
    return v[0]
  v

test_cardinality = ( num, bounds ) ->
  return false if num >= bounds[0]
  return true if bounds[1] is -1
  num <= bounds[1]

class Email

class Field
  constructor: (opts) ->
    # defaults
    @cardinality = [0,1]
    @type = String
    # override defaults with user options
    (@[unshortcut k] = v) for own k, v of opts
  
  validate : (data, cb) ->
    data = array_box data
    card_ok = test_cardinality data.length, @cardinality
    return cb( 'Cardinality Error' ) unless card_ok
    # TODO: validate content
    cb null, yes
  
  decode : (rdf_value) ->
    if @type is Email
      rdf_value.value.split(':')[1]
    else
      rdf_value.value
  
  decode_and_unbox : (rdf_value_arr) ->
    # decode
    arr = ( @decode rdf_value for rdf_value in rdf_value_arr )
    # unbox
    if @is_multi_valued() then arr else array_unbox arr
  
  # encodes to NT or NULL
  encode : (value) ->
    return null unless value?
    if @type is Email
      "<mailto:#{value}>"
    else
      JSON.stringify value
  
  encode_and_box : (value) ->
    value = array_box value
    @encode v for v in value
  
  execute_update : ( client, graph, uri, value, cb ) ->
    value = @encode_and_box value
    client.set graph, uri, @path, value, no, (err, res) ->
      if err?
        cb err
      else
        cb null, yes
  
  is_multi_valued : -> @cardinality[1] is -1
  is_optional : -> @cardinality[0] is 0

generate_primary_load_query = ( graph, uri, fields ) ->
  projections = []
  bgps = []
  for own name, field of fields when not field.is_multi_valued()
    projections.push name
    bgp = "#{uri} #{field.path} ?#{name}"
    bgp = if field.is_optional() then "optional { #{bgp} }" else "#{bgp} ."
    bgps.push bgp
  bgps = bgps.join "\n"
  projections = ( "?#{p}" for p in projections ).join "\n"
  from = if graph? then " from #{graph} " else ""
  "select distinct \n #{projections}\n #{from} where { \n #{bgps} \n } limit 1"

generate_secondary_load_queries = ( graph, uri, fields ) ->
  from = if graph? then " from #{graph} " else ""
  for own name, field of fields when field.is_multi_valued()
      "select distinct ?#{name} #{from} where { #{uri} #{field.path} ?#{name} }"

load_record = (client, graph, uri, fields, cb) ->
  record = {}
  record.save = (cb) -> # closure. will remember settings
    save_record client, graph, uri, fields, record, cb
  
  queries = generate_secondary_load_queries graph, uri, fields
  queries.push generate_primary_load_query graph, uri, fields
  pending = queries.length
  for query in queries
    client.cols query, ( err, res ) ->
      for own field_name, rdf_value_arr of res
        field = fields[ field_name ]
        rdf_value_arr = (v for v in rdf_value_arr when v?) # filter nulls
        record[field_name] = field.decode_and_unbox rdf_value_arr
      cb null, record if --pending is 0

# TODO: mantain order
load_records = (client, graph, query, fields, cb) ->
  records = []
  client.col query, (err, res) ->
    if res.length is 0 # return right away if no results
      cb null, []
      return
    # lets fire one query per result ( parallel )
    pending = res.length
    i = 0
    for uri_s in res
      uri_n = "<#{uri_s.value}>"
      load_record client, graph, uri_n, fields, (err, res) ->
        records.push res
        cb null, records if --pending is 0

save_record = (client, graph, uri, fields, record, cb) ->
  # how many queries will we fire?
  pending = 0
  pending++ for own k of fields
  # fire in parallel
  for own field_name, field of fields
    field.execute_update client, graph, uri, record[field_name], (err, res) ->
      if err?
        console.log 'ERROR updating field' + field_name
        console.log err
      cb? null, yes if --pending is 0

# kludge:
exports.load_record = load_record
exports.load_records = load_records
exports.save_record = save_record
exports.Email = Email
exports.Field = Field

