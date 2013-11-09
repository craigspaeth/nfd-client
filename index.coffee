express = require 'express'
{ PORT, NODE_ENV, API_URL, MANDRILL_APIKEY } = config = require './config'
{ exec } = require 'child_process'
sd = require('sharify').data
request = require 'superagent'
accounting = require 'accounting'
uaMiddlware = require './components/user-agent/middleware'
mandrill = require('node-mandrill')(MANDRILL_APIKEY)
sharify = require 'sharify'
_ = require 'underscore'

app = module.exports = express()

# Setup
app.set 'views', __dirname + '/components/'
app.set 'view engine', 'jade'
app.use express.logger('dev')
app.use express.favicon()
app.use express.bodyParser()
app.use(require './lib/asset-middleware') if NODE_ENV is 'development'
app.use express.static __dirname + '/public'
app.use sharify _.pick config,
  'API_URL'
  'NODE_ENV'
  'PRICES'
  'MANDRILL_APIKEY'
  'MIXPANEL_KEY'
app.locals.accounting = accounting
  
# Routes
app.use uaMiddlware
app.get '/', (req, res) ->
  res.render 'home-page'
app.get '/search*', (req, res) ->
  res.render 'home-page'
app.get '/about', (req, res) ->
  res.render 'about-page'
app.post '/feedback', (req, res) ->
  mandrill '/messages/send',
    message:
      to: [{ email: 'nofeedigs@gmail.com' }]
      from_email: req.body.email or 'nofeedigs@gmail.com'
      subject: "Feedback"
      text: req.body.body
  , (err, resp) ->
    return req.next err if err
    res.send resp

# Fetch neighborhoods and Start server
request.get(API_URL + '/neighborhoods').end (res) ->
  sd.NEIGHBORHOODS = res.body
  app.listen PORT, -> console.log "Listening on #{PORT}"