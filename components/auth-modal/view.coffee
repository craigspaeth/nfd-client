_ = require 'underscore'
Backbone = require 'backbone'
vent = require '../../lib/vent.coffee'
User = require '../../models/user.coffee'
qs = require 'querystring'

module.exports = class AuthModal extends Backbone.View

  el: '#auth-modal-container'

  initialize: ->
    vent.on 'auth-modal:open', @onOpen

  onOpen: (options = {}) =>
    @$el.show()
    @$el.attr 'data-state', options.state ? 'signup'
    _.defer => @$('input:visible').first().focus()

  events:
    'submit #auth-modal-signup-form': 'signup'
    'click #auth-modal-thank-you .rounded-button': 'closeThankYou'
    'click #auth-modal-signup-link': 'signupMode'
    'click #auth-modal-login-link': 'loginMode'

  signup: (e) ->
    e.preventDefault()
    new User(qs.parse(@$('#auth-modal-signup-form').serialize())).save null,
      success: (user) =>
        @$('#auth-modal-thank-you-name').html user.get('name')
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

  signupMode: ->
    vent.trigger 'auth-modal:open', { state: 'signup' }

  loginMode: ->
    vent.trigger 'auth-modal:open', { state: 'login' }