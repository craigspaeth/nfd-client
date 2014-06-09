Backbone = require 'backbone'
sd = require('sharify').data
HomepageView = require '../home-page/view.coffee'
AuthModal = require '../auth-modal/view.coffee'
SettingsView = require '../settings-page/view.coffee'
ResetPasswordView = require '../reset-password-page/view.coffee'
ListingPageView = require '../listing-page/view.coffee'
vent = require '../../lib/vent.coffee'
User = require '../../models/user.coffee'

# Plugins
require '../../lib/jquery.infinite-scroll.coffee'

$ ->
  Backbone.$ = $
  
  # Start some static code
  require '../modal/client.coffee'
  require '../feedback-modal/client.coffee'
  require '../main-header/client.coffee'

  # Expose the current user
  vent.on 'login', (user) -> window.currentUser = user
  vent.on 'logout', (user) -> delete window.currentUser
  vent.trigger 'login', new User(sd.USER) if sd.USER

  # Initialize code based on InitRouter
  new InitRouter
  Backbone.history.start pushState: true

  # Project-wide views
  new AuthModal

class InitRouter extends Backbone.Router

  routes:
    '': 'home'
    'search/*params': 'home'
    'settings': 'settings'
    'reset-password': 'resetPassword'

  home: ->
    new HomepageView

  settings: ->
    new SettingsView

  resetPassword: ->
    new ResetPasswordView

  listingPage: ->
    new ListingPageView