mu2Express = require("mu2Express")
http = require 'http'
fs = require 'fs'
url = require 'url'
Client = require('request-json').JsonClient
client = new Client('http://localhost:3000')

express = require("express")
app = express()
app.engine "mustache", mu2Express.engine
app.set "view engine", "mustache"
app.set "views", __dirname + "/views"

app.get "/*", (req, response) ->
  if req.url == '/favicon.ico'
    response.status(404);
    return response.render('')
  url_parts = url.parse req.url, true
  view_path = __dirname + "/views" + url_parts.pathname.replace(/\/*/, '') + '.mustache'
  if fs.existsSync(view_path)
    template = url_parts.pathname.replace(/\/*/, '')
  else
    ary = url_parts.pathname.replace(/\/$/, '').split('/')
    if ary.length % 2 == 0
      template = ary[ary.length - 1] + '/index'
    else
      template = ary[ary.length - 2] + '/show'
  client.get '/api'+url_parts.pathname + '.json' + url_parts.search, (err, res, body) ->
    console.log 'body', body
    response.render template,
      locals: body
app.listen 8080
