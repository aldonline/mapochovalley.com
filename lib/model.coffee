mongoose = require 'mongoose'
facebook_express = require 'facebook-express'
config = require './config'

mongoose.connect 'mongodb://localhost/test'

Schema = mongoose.Schema
ObjectId = Schema.ObjectId

Person = new Schema
  uid :
    type: Number, unique: true
  name : String
  country: String
  locale: String
    
  tagline : String
  twitter_id : String
  email : String
  meetup_id : String
  
  is_investor: Boolean
  is_entrepreneur : Boolean
  is_developer : Boolean
  is_sup : Boolean
  sup_date : Date


mongoose.model 'Person', Person
Person = mongoose.model 'Person'

fbx = facebook_express.create_helper
  app_id: config.app_id
  app_secret: config.app_secret
  domain: config.domain
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
    p = new Person
    p.name = data.registration.name
    p.email = data.registration.email
    p.uid = data.user_id
    p.country = data.user.country
    p.locale = data.user.locale
    
    p.save -> console.log ['saved new user', p]
    
    cb '/profile/' + p.uid


class User
  constructor : (@id) ->
    @mv_url = "http://dev.mapochovalley.com/#{@id}"
    @pic_url = "http://graph.facebook.com/#{@id}/picture?type=large"
  add_fb_object : (obj) -> ( this[k] = v ) for k, v of obj

# deprecated. this method is an unnecessary abstraction atop the mongoose API
get_user = (id, cb) -> Person.findOne {uid:id}, (err, res) -> cb res

exports.Person = Person
exports.fbx = fbx
exports.get_user = get_user # <-- deprecated


###

In Mongo
------------
db.people.save( {uid:545415493, name:'Aldo Bucchi'} )


In Node/Mongoose
-----------
var m = require('mongoose')
m.connect('mongodb://localhost/test')
var Schema = m.Schema
var ObjectId = Schema.ObjectId
var Person = new Schema({uid:Number, name:String})
m.model('Person', Person)
var p = m.model('Person')

p.find( {uid:545415493}, function(err, res){
  console.log(res)
})


p.findById( 'non-existent', function(err, res){
  console.log(res)
})

p.findById( '4d62af09a007a28d0d000001', function(err, res){
  console.log('Got Result')
  console.log(res.name)
  res.name = 'Waldo Bucchi'
  console.log(res.name)  
  res.save(function(){
    console.log('saved')
  })
})


###