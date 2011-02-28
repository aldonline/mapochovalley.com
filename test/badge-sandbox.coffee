express = require 'express'
badge_core = require '../lib/badge/core'

server = express.createServer()
badge_core.init server

server.listen 80