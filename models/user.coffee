Backbone = require 'backbone'
accounting = require 'accounting'
moment = require 'moment'
{ parse } = require 'url'
{ API_URL, API_ID, API_SECRET } = require('sharify').data
request = require 'superagent'

module.exports = class User extends Backbone.Model
  
  urlRoot: -> "#{API_URL}/users"

  @login: (email, password, callback) ->
    request.post(API_URL + '/access-token').send(
      email: email
      password: password
      id: API_ID
      secret: API_SECRET
    ).end (res) ->
      callback res
      request.post('/login').send(res.body).end()
      
  @logout: (callback) ->
    request.post('/logout').end callback