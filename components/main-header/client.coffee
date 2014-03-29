vent = require '../../lib/vent.coffee'
template = require './index.jade'
User = require '../../models/user.coffee'

vent.on 'login logout', (user) ->
  $('#main-header').replaceWith $ template
    user: user
    path: location.pathname
    belowHero: $('.home-page-filters-fixed').length > 0

$(document).on 'click', '#main-header [href*=logout]', (e) ->
  e.preventDefault()
  vent.trigger 'logout'
  User.logout()

$(document).on 'click', '[href*=login]', (e) ->
  vent.trigger 'auth-modal:open', state: 'login'
  false