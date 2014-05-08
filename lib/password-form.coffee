qs = require 'querystring'
_ = require 'underscore'

module.exports =

  serialize: ->
    data = qs.parse $(".rounded-form").serialize()
    if data['repeat-new-password'] and data['new-password'] isnt data['repeat-new-password']
      @renderError "Passwords don't match"
      return null
    if data['new-password']
      data.password = data['new-password']
    data = _.pick data, 'name', 'email', 'password'
    delete data[key] for key, val of data when not val
    data

  submit: (e) ->
    e.preventDefault()
    $btn = @$('.rounded-form button')
    $btn.first().addClass 'is-loading'
    @$('.rounded-form-error').html ''
    currentUser.save @serialize(),
      error: (m, err) => @renderError err
      complete: => $btn.removeClass 'is-loading'
    false

  renderError: (err) ->
    @$('.rounded-form-error').html err