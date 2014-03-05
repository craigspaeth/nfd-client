_ = require 'underscore'
Backbone = require 'backbone'
vent = require '../../lib/vent.coffee'
User = require '../../models/user.coffee'

module.exports = class AuthModal extends Backbone.View

  el: '#auth-modal-container'

  initialize: ->
    vent.on 'auth-modal:open', @onOpen

  onOpen: =>
    @$el.show()
    _.defer => @$('[type="email"]').focus()

  events:
    'submit #auth-modal-signup-form': 'signup'

  signup: (e) ->
    e.preventDefault()
    new User(
      email: @$('#auth-modal-signup-form [type="email"]').val()
      password: @$('#auth-modal-signup-form [type="password"]').val()
    ).save null,
      success: ->
        alert "Thanks for signing up!"
      error: (m, xhr) =>
        @$('#auth-modal-right .auth-modal-error').html xhr.responseJSON.error