mongoose = require 'mongoose'

mongoose.connect 'mongodb://localhost/test'

Schema = mongoose.Schema
ObjectId = Schema.ObjectId

Person = new Schema
  uid :
    type: Number, unique: true
  name : String
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

exports.Person = Person

###

In Mongo
------------
db.people.save( {uid:545415493, name:'Aldo Bucchi'} )


In Node
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