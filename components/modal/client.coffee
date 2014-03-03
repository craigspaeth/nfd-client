# Hide a modal on clicking close or off the window
$(document).on 'click', '.modal-container', (e) ->
  return unless $(e.target).is('.modal-container') or $(e.target).is('.modal-close')
  $(e.target).closest('.modal-container').hide()