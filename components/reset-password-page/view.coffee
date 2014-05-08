_ = require 'underscore'
Backbone = require 'backbone'
numeral = require 'numeral'
vent = require '../../lib/vent.coffee'
qs = require 'querystring'
PasswordForm = require '../../lib/password-form.coffee'

module.exports = class ResetPasswordView extends Backbone.View
  
  _.extend @prototype, PasswordForm

  el: 'body'

  initialize: ->
    @$(':input').first().focus()

  events:
    'submit form': 'submit'