Backbone = require 'backbone'
accounting = require 'accounting'
moment = require 'moment'
{ parse } = require 'url'
{ API_URL } = require('sharify').data

module.exports = class User extends Backbone.Model
  
  urlRoot: -> "#{API_URL}/users"