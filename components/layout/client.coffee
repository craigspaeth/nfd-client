Backbone = require 'backbone'
sd = require('sharify').data
HomepageView = require '../home-page/view.coffee'
AuthModal = require '../auth-modal/view.coffee'

# Plugins
require '../../lib/jquery.infinite-scroll.coffee'

$ ->
  Backbone.$ = $
  mixpanel.track 'Viewed page', { path: location.pathname }
  
  # Star some static code
  require '../modal/client.coffee'
  require '../feedback-modal/client.coffee'

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