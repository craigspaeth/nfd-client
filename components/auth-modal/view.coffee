_ = require 'underscore'
Backbone = require 'backbone'
vent = require '../../lib/vent.coffee'
User = require '../../models/user.coffee'
qs = require 'querystring'

module.exports = class AuthModal extends Backbone.View

  el: '#auth-modal-container'

  initialize: ->
    vent.on 'auth-modal:open', @onOpen
    vent.on 'login', (user) => @$('.auth-modal-name').html user.get('name')

  onOpen: (options = {}) =>
    @$el.show()
    @$('.auth-modal-error').html '&nbsp;'
    @$el.attr 'data-state', options.state ? 'signup'
    _.defer => @$('input:visible').first().focus()

  onError: (err) ->
    @$('.auth-modal-error').html err
    @$('form button').addClass('rounded-button-error')
    setTimeout (=> @$('form button').removeClass 'rounded-button-error'), 1000

  login: (email, password) ->
    User.login email, password, (res) =>
      return @onError res.body.error if res.error
      vent.trigger 'login', new User(res.body)
      @$el.attr('data-state', 'welcome-login')
      setTimeout @close, 1000

  events:
    'submit #auth-modal-signup-form': 'onSignup'
    'submit #auth-modal-login-form': 'onLogin'
    'click #auth-modal-thank-you .rounded-button, #auth-modal-login-welcome .rounded-button': 'close'
    'click #auth-modal-signup-link': 'signupMode'
    'click #auth-modal-login-link': 'loginMode'

  onSignup: (e) ->
    e.preventDefault()
    new User(qs.parse(@$('#auth-modal-signup-form').serialize())).save null,
      success: (user) =>
        vent.trigger 'login', user
        @$el.attr('data-state', 'thank-you')
        { email, password } = qs.parse @$('#auth-modal-signup-form').serialize()
        @login email, password
      error: (m, xhr) =>
        @onError xhr.responseJSON.error
      complete: =>
        @$('#auth-modal-signup-form button').removeClass('is-loading')
    @$('#auth-modal-signup-form button').addClass('is-loading')

  onLogin: (e) ->
    e.preventDefault()
    { email, password } = qs.parse @$('#auth-modal-login-form').serialize()
    @login email, password

  close: =>
    @$el.hide()
    @$el.attr('data-state', '')

  signupMode: ->
    vent.trigger 'auth-modal:open', { state: 'signup' }

  loginMode: ->
    vent.trigger 'auth-modal:open', { state: 'login' }