Backbone = require 'backbone'
accounting = require 'accounting'
moment = require 'moment'
{ parse } = require 'url'
{ API_URL, API_ID, API_SECRET } = require('sharify').data
request = require 'superagent'

module.exports = class User extends Backbone.Model
  
  idAttribute: "_id"

  urlRoot: -> "#{API_URL}/users"

  addAlert: (name, query) ->
    @set alerts: [] unless @get('alerts')?.length
    @get('alerts').push { name: name, query: query }
    @save()
    @refreshSession()

  sync: (method, model, options) ->
    options.data ?= {} if method is 'read'
    options.data.accessToken = @get('accessToken') if method is 'read'
    @once 'sync', => @refreshSession() if method is 'update'
    super

  refreshSession: ->
    return
    request.post('/login').end()

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

  @resetPassword: (email, callback) ->
    request.post("#{API_URL}/users/reset-password?email=#{email}").end callback