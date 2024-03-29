# Confirm
#
# Prompts native confirm dialog before activating link.
#
# ### Markup
#
# `<a>`
#
# ``` definition-table
# Attribute - Description
#
# `data-confirm` - Message to pass to `confirm()`.
# ```
#
#     <a href="/" data-confirm="Are you sure?">Delete</a>

$(document).delegate 'a[data-confirm]', 'click', (event) ->
  if message = $(this).attr 'data-confirm'
    # Prompt message with native confirm dialog
    unless confirm message
      # Prevent other handlers on the document from running
      event.stopImmediatePropagation()
      # Prevent default action from running
      return false