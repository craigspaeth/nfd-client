Backbone = require 'backbone'
sd = require('sharify').data
HomepageView = require '../home-page/view.coffee'
AuthModal = require '../auth-modal/view.coffee'
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

class InitRouter extends Backbone.Router

  routes:
    '': 'home'
    '/search*': 'home'

  home: ->
    new AuthModal
    new HomepageView