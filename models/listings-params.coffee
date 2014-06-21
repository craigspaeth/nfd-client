_ = require 'underscore'
Backbone = require 'backbone'
qs = require 'querystring'

module.exports = class ListingsParams extends Backbone.Model
  
  defaults:
    size: 10
    neighborhoods: []
    sort: 'newest'
    'bed-min': 0
    'bath-min': 1
  
  toQuerystring: ->
  	qs.stringify @toJSON()