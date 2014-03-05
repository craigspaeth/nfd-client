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
  $modal.hide()
  false

# Clicking "Give Feedback opens the modal"
$('[href=feedback]').click ->
  $modal.show()
  $modal.find('input').first().focus()
  false