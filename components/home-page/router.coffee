_ = require 'underscore'
Backbone = require 'backbone'
querystring = require 'querystring'

module.exports = class HomepageRouter extends Backbone.Router
  
  initialize: (opts) ->
    { @listings } = opts
  
  routes:
    'search/*queryString': 'search'
    
  search: (queryString) ->
    @listings.params.set querystring.parse queryString