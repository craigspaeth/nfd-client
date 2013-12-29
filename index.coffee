require 'newrelic'
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
path = require 'path'

# Create app
app = module.exports = express()

# Setup Sharify
sharify.data = _.pick config,
  'API_URL'
  'NODE_ENV'
  'PRICES'
  'MANDRILL_APIKEY'
  'MIXPANEL_KEY'
  'HERO_UNITS'

# General express middleware
app.use sharify
app.use express.favicon()
app.use express.logger("dev")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router

# Set components to be views
app.set 'views', __dirname + '/components/'
app.set 'view engine', 'jade'

# Inject app-wide locals
app.locals.accounting = accounting

# Development only
if "development" is NODE_ENV
  app.use express.errorHandler()
  app.use require("stylus").middleware
    src: __dirname
    dest: __dirname + "/public"
  app.use require("browserify-dev-middleware")
    src: __dirname
    transforms: [require("jadeify2"), require('caching-coffeeify')]
  
# Routes
app.use uaMiddlware
app.get '/', (req, res) -> res.render 'home-page'
app.get '/search*', (req, res) -> res.render 'home-page'
app.get '/about', (req, res) -> res.render 'about-page'
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

# More general middleware
app.use express.static __dirname + "/public"

# Fetch neighborhoods and Start server
request.get(API_URL + '/neighborhoods').end (res) ->
  sharify.data.NEIGHBORHOODS = res.body
  app.listen PORT, -> console.log "Listening on #{PORT}"