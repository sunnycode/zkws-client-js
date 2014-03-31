
_  = require 'underscore'
io = require 'socket.io-client'

UpdateClient = (server, opts) ->
  client = {}
  client.watches = {}
  client.socket = io.connect server, opts

  client.socket.on 'connect', -> console.log("socket connected")
  client.socket.on 'update', (data) -> client.watches[data.path].callback.apply {}, arguments

  client.watch = (details, callback) ->
    client.watches[details.path] = {details:details,callback:callback}
    client.socket.emit 'watch', details

  client.socket.on 'disconnect', () ->
    console.log("ouch! socket diconnected")
  client

#
# sample usage
#
#callback = (path) -> (data) -> console.log 'updated!', path, data
#udc = new UpdateClient('localhost', {port:8080})
#udc.watch({path:'/foo'}, callback("/foo"))
#udc.watch({path:'/bar'}, callback("/bar"))

