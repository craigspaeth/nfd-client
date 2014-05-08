_ = require 'underscore'
Backbone = require 'backbone'
numeral = require 'numeral'
vent = require '../../lib/vent.coffee'
PasswordForm = require '../../lib/password-form.coffee'

module.exports = class SettingsView extends Backbone.View
  
  el: 'body'

  _.extend @prototype, PasswordForm

  events:
    'click .settings-page-remove-alert': 'removeAlert'
    'submit #settings-page-basic': 'submit'

  removeAlert: (e) ->
    $li = $(e.currentTarget).parent()
    alert = currentUser.get('alerts')[$li.index()]
    return unless confirm "Are you sure you want to remove #{alert.name}"
    alerts = currentUser.get('alerts')
    alerts.splice($li.index(), 1)
    currentUser.save alerts: alerts
    $li.remove()