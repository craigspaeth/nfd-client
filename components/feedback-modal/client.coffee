module.exports.init = ->
  
  $modal = $ '#feedback-modal-bg'

  # Submitting the form sends an email
  $modal.find('form').on 'submit', ->
    $.ajax(
      url: '/feedback'
      type: 'POST'
      data:
        email: $modal.find('[type=email]').val()
        body: $modal.find('textarea').val()
      success: -> console.log arguments
    )
    $modal.hide()
    false
  
  # Clicking "Give Feedback opens the modal"
  $('[href=feedback]').click ->
    $modal.show()
    $modal.find('input').first().focus()
    false