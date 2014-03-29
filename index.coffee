require 'newrelic'
express = require 'express'
{ PORT, NODE_ENV, API_URL, MANDRILL_APIKEY, SESSION_SECRET } = config = require './config'
{ exec } = require 'child_process'
sd = require('sharify').data
request = require 'superagent'
accounting = require 'accounting'
mandrill = require('node-mandrill')(MANDRILL_APIKEY)
sharify = require 'sharify'
_ = require 'underscore'
path = require 'path'
User = require './models/user'

# Create app
app = module.exports = express()

# Setup Sharify
sharify.data = _.pick config,
  'API_URL'
  'API_ID'
  'API_SECRET'
  'NODE_ENV'
  'PRICES'
  'MANDRILL_APIKEY'
  'MIXPANEL_KEY'
  'HERO_UNITS'
  'ENABLE_ADS'
app.use sharify

# General express middleware/settings
app.set 'views', __dirname + '/components/'
app.set 'view engine', 'jade'
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.cookieSession secret: SESSION_SECRET
app.locals.accounting = accounting

# Development only
if "development" is NODE_ENV
  app.use express.errorHandler()
  app.use require("stylus").middleware
    src: __dirname
    dest: __dirname + "/public"
  app.use require("browserify-dev-middleware")
    src: __dirname
    transforms: [require("jadeify"), require('caching-coffeeify')]

# Static middleware
app.use express.static __dirname + "/public"

# Auth middleware
app.use (req, res, next) ->
  return next() unless req.session.user?
  res.locals.user = req.user = new User req.session.user
  res.locals.sharify.data.USER = req.user.toJSON()
  next()

# Routes
app.get '/', (req, res) -> res.render 'home-page', path: '/'
app.get '/search*', (req, res) -> res.render 'home-page'
app.get '/about', (req, res) -> res.render 'about-page', path: '/about'
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
app.post '/login', (req, res) ->
  req.session.user = _.pick req.body, 'name', 'email', 'accessToken'
  res.send { success: true }
app.post '/logout', (req, res) ->
  req.session.user = null
  res.send { success: true }

# Fetch neighborhoods and Start server
request.get(API_URL + '/neighborhoods').end (res) ->
  sharify.data.NEIGHBORHOODS = res.body
  app.listen PORT, -> console.log "Listening on #{PORT}"