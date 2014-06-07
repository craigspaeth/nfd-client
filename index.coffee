require 'newrelic'
Backbone = require 'backbone'
express = require 'express'
{ exec } = require 'child_process'
sd = require('sharify').data
request = require 'superagent'
accounting = require 'accounting'
mandrill = require('node-mandrill')(MANDRILL_APIKEY)
sharify = require 'sharify'
_ = require 'underscore'
path = require 'path'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
cookieSession = require 'cookie-session'
errorHandler = require 'errorhandler'
{ PORT, NODE_ENV, API_URL, MANDRILL_APIKEY, SESSION_SECRET, APP_URL } = config = require './config'

# Sharify data and the modules that use it
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
User = require './models/user'

# Create app
app = module.exports = express()

# Override sync
Backbone.sync = require 'backbone-super-sync'

# General express middleware/settings
app.use sharify
app.set 'views', __dirname + '/components/'
app.set 'view engine', 'jade'
app.use bodyParser()
app.use cookieParser()
app.use cookieSession secret: SESSION_SECRET
app.locals.accounting = accounting

# Development only
if "development" is NODE_ENV
  app.use errorHandler()
  app.use require("stylus").middleware
    src: __dirname
    dest: __dirname + "/public"
  app.use require("browserify-dev-middleware")
    src: __dirname
    transforms: [require("jadeify"), require('caching-coffeeify')]

# Static middleware
app.use express.static __dirname + "/public"

# Login middleware
setUser = (req, res, next) ->
  return next() unless req.session.user?
  res.locals.user = req.user = new User req.session.user
  res.locals.sd.USER = req.user?.toJSON()
  next()

login = (req, res, next) ->
  user = new User req.user?.toJSON() or if _.keys(req.body).length then req.body else req.query
  return res.redirect '/' unless user.get('_id') and user.get('accessToken')
  user.fetch
    error: (m, res) ->
      next res.error.toString()
    success: ->
      req.session.user = user.toJSON()
      setUser req, res, next

# Routes
app.use setUser
app.get '/', (req, res) ->
  res.render 'home-page', path: '/'
app.get '/search*', (req, res) ->
  res.render 'home-page', path: '/'
app.get '/about', (req, res) ->
  res.render 'about-page'
app.get '/settings', (req, res) ->
  res.redirect '/' unless req.user
  res.render 'settings-page'
app.get '/reset-password', login, (req, res) ->
  res.redirect '/' unless req.user
  res.render 'reset-password-page'
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
app.post '/login', login, (req, res, next) ->
  res.send { success: true }
app.post '/logout', (req, res) ->
  req.session.user = null
  res.send { success: true }

# Fetch neighborhoods and Start server
request.get(API_URL + '/neighborhoods').end (res) ->
  sharify.data.NEIGHBORHOODS = res.body
  app.listen PORT, -> console.log "Listening on #{PORT}"