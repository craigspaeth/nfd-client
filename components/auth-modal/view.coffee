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
    'click #auth-modal-thank-you .rounded-button': 'closeThankYou'

  signup: (e) ->
    e.preventDefault()
    new User(
      email: @$('#auth-modal-signup-form [type="email"]').val()
      password: @$('#auth-modal-signup-form [type="password"]').val()
    ).save null,
      success: =>
        @$el.attr('data-state', 'thank-you')
      error: (m, xhr) =>
        @$('#auth-modal-right .auth-modal-error').html xhr.responseJSON.error
        @$('#auth-modal-right button').addClass('rounded-button-error')
        setTimeout (=> @$('#auth-modal-right button').removeClass 'rounded-button-error'), 1000
      complete: =>
        @$('#auth-modal-signup-form button').removeClass('is-loading')
    @$('#auth-modal-signup-form button').addClass('is-loading')

  closeThankYou: ->
    @$el.hide()
    @$el.attr('data-state', '')