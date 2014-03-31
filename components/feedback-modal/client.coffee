vent = require '../../lib/vent.coffee'
template = require './index.jade'

vent.on 'login logout', (user) ->
  $('#feedback-modal-bg').replaceWith $ template
    user: user

# Submitting the form sends an email
$(document).on 'submit', '#feedback-modal-bg form', (e) ->
  $.ajax(
    url: '/feedback'
    type: 'POST'
    data:
      email: $('#feedback-modal-bg [type=email]').val()
      body: $('#feedback-modal-bg textarea').val()
  )
  $('#feedback-modal-bg').hide()
  false

# Clicking "Give Feedback opens the modal"
$(document).on 'click', '[href=feedback]', ->
  $('#feedback-modal-bg').show()
  if currentUser?
    $('#feedback-modal-bg textarea').first().focus()
  else
    $('#feedback-modal-bg input').first().focus()
  false