window.$ = require 'jquery'
require '../../lib/jquery.infinite-scroll.coffee'
Backbone = require 'backbone'
sd = require('sharify').data
HomepageView = require '../home-page/view.coffee'
feedbackModal = require '../feedback-modal/client.coffee'

$ ->
  Backbone.$ = $
  mixpanel.track 'Viewed page', { path: location.pathname }
  feedbackModal.init()
  if location.pathname.match new RegExp '^/$|^/search.*'
  	window.view = new HomepageView
  	Backbone.history.start pushState: true