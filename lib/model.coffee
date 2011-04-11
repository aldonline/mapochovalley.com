sparql = require 'sparql'
facebook_express = require 'facebook-express'

sparql_record = require './sparql_record'
config = require './config'

Field = sparql_record.Field
Email = sparql_record.Email

client = new sparql.Client config.sparql_endpoint
client.prefix_map = 
  mv : 'http://mapochovalley.com/id/'
  foaf : 'http://xmlns.com/foaf/0.1/'

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

get_person = ( uid, cb ) ->
  sparql_record.load_record client, 'mv:graph', 'mv:fb'+uid, person_fields, cb

get_members = ( cb ) ->
  q = 'select distinct ?p where { mv:mv mv:member ?p }'
  sparql_record.load_records client, 'mv:graph', q, person_fields, cb

fbx = facebook_express.create_helper
  app_id: config.app_id
  app_secret: config.app_secret
  url: config.url
  registration:
    fields: [
      {name:'name'}
      {name:'email'}
    ]
  on_registration: ( data, cb ) ->
  
    ###
    { algorithm: 'HMAC-SHA256',
      expires: 1299265200,
      issued_at: 1299260933,
      oauth_token: '197414136954002|2.NDEwQbQe1gGSM_Tg786Vyw__.3600.1299265200-545415493|NZmfI6ikmxcVtD90V2YoiJX1XME',
      registration: 
       { name: 'Aldo Bucchi',
         email: 'aldo.bucchi@gmail.com' },
      registration_metadata: { fields: '[{"name":"name"},{"name":"email"}]' },
      user: { country: 'cl', locale: 'en_US' },
      user_id: '545415493' }
    ###

    uid = data.user_id
    client.query "insert data into graph mv:graph { mv:mv mv:member mv:fb#{uid} }", (err, res) ->
      get_person uid, (err, p) ->
        p.name = p.badge_name = data.registration.name
        p.email = data.registration.email
        p.uid = uid
        p.country = data.user.country
        p.locale = data.user.locale
        p.save -> 
          cb '/profile/' + p.uid

exports.fbx = fbx
exports.get_person = get_person
exports.get_members = get_members
