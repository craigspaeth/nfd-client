# Submitting the form sends an email
$('#feedback-modal-bg form').on 'submit', ->
  $.ajax(
    url: '/feedback'
    type: 'POST'
    data:
      email: $('#feedback-modal-bg [type=email]').val()
      body: $('#feedback-modal-bg textarea').val()
    success: -> console.log arguments
  )
  $('#feedback-modal-bg').hide()
  false

# Clicking "Give Feedback opens the modal"
$('[href=feedback]').click ->
  $('#feedback-modal-bg').show()
  $('#feedback-modal-bg input').first().focus()
  false