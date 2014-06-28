Backbone = require 'backbone'
sd = require('sharify').data
_ = require 'underscore'
ListingsParams = require '../models/listings-params.coffee'

module.exports = class Listings extends Backbone.Collection
  
  url: -> "#{sd.API_URL}/listings"
  
  initialize: (attrs, options) ->
    @model = require '../models/listing.coffee'
    @params = new ListingsParams options?.params
    @params.on 'change', =>
      @trigger 'requestReset'
      @fetch(reset: true)
    
  fetch: (options = {}) =>
    opts = _.extend options, data: _.extend @params.toJSON(), options.data
    super opts
  
  parse: (res) ->
    { @total, @count } = res
    res.results