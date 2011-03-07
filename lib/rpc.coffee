minirpc = require 'minirpc'
shell = require './shell'

# create an RPC proxy so we can call server side code from the client
rpc = new minirpc.RPC

rpc.get_badge_data = -> ( cb ) ->
  s = shell.for_request rpc._request
  if s? then s.get_badge_data cb else cb 'not authorized'

rpc.set_badge_data = ( data ) -> ( cb ) ->
  s = shell.for_request rpc._request
  if s? then s.set_badge_data data, cb else cb 'not authorized'

module.exports = rpc