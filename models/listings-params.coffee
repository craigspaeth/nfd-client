Backbone = require 'backbone'
querystring = require 'querystring'

module.exports = class ListingsParams extends Backbone.Model
  
  defaults:
    size: 10
    neighborhoods: []
    sort: 'newest'
    'bed-min': 0
    'bath-min': 1
  
  toQuerystring: ->
    querystring.stringify @toJSON()