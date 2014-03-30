_ = require 'underscore'
_.mixin require 'underscore.string'
Backbone = require 'backbone'
vent = require '../../lib/vent.coffee'
User = require '../../models/user.coffee'
template = require './index.jade'

module.exports = class AlertsModal extends Backbone.View

  initialize: ->
    @params = @collection.params
    vent.on 'alerts-modal:open', @open

  open: =>
    @$el.html(template params: @params, _: _).show().find('input').first().focus()