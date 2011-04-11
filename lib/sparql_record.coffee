assert = require 'assert'
sparql = require 'sparql'

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
  
  is_multi_valued : -> @cardinality[1] is -1
  is_optional : -> @cardinality[0] is 0

generate_primary_load_query = ( graph, uri, fields ) ->
  projections = []
  lines = []
  for own name, field of fields
    unless field.is_multi_valued()
      projections.push name
      line = "#{uri} #{field.path} ?#{name}"
      line = if field.is_optional() then "optional { #{line} }" else "#{line} ."
      lines.push line
  lines = lines.join "\n"
  projections = ( "?#{p}" for p in projections ).join "\n"
  from = if graph? then " from #{graph} " else ""
  query = "select distinct \n #{projections}\n #{from} where { \n #{lines} \n } limit 1"
  query

generate_secondary_load_queries = ( graph, uri, fields ) ->
  from = if graph? then " from #{graph} " else ""
  for own name, field of fields when field.is_multi_valued()
      "select distinct ?#{name} #{from} where { #{uri} #{field.path} ?#{name} }"

load_record = (client, graph, uri, fields, cb) ->
  record = {}
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

person_fields = 
  name:
    new Field p: 'foaf:name', c: [1,1]
  email:
    new Field p: 'foaf:mbox', t: Email, c: [1,1]
  uid: 
    new Field p: 'mv:facebook_id', t: Number, c: [0,1]
  country: 
    new Field path: 'mv:country'
  locale: 
    new Field path: 'mv:locale'
  badge_name: 
    new Field path: 'mv:badge_name'
  tagline: 
    new Field path: 'mv:tagline'
  twitter_id: 
    new Field path: 'mv:twitter_id'
  meetup_id: 
    new Field path: 'mv:meetup_id'
  tags: 
    new Field path: 'mv:tag', c: [0,-1]


client = new sparql.Client 'http://localhost:8898/sparql'
client.prefix_map = 
  mv : 'http://mapochovalley.com/id/'

load_record client, null, 'mv:fb545415493', person_fields, (err, res) ->
  console.log res



