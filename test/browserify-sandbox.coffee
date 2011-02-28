express = require 'express'
browserify = require 'browserify'
jsmin = require 'jsmin'

server = express.createServer()

server.use browserify
  base : __dirname + '../js-src'
  mount : '/browserify.js'
  filter : jsmin

server.listen 9797
console.log 'Listening on 9797...'