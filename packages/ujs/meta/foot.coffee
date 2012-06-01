$.ajaxPrefilter (options, originalOptions, xhr) ->
  rails.CSRFProtection xhr  unless options.crossDomain

$(document).delegate rails.linkDisableSelector, "ajax:complete", ->
  rails.enableElement $(this)

$(document).delegate rails.linkClickSelector, "click.rails", (e) ->
  link = $(this)
  method = link.data("method")
  data = link.data("params")
  return rails.stopEverything(e)  unless rails.allowAction(link)
  rails.disableElement link  if link.is(rails.linkDisableSelector)
  if link.data("remote") isnt `undefined`
    return true  if (e.metaKey or e.ctrlKey) and (not method or method is "GET") and not data
    rails.enableElement link  if rails.handleRemote(link) is false
    false
  else if link.data("method")
    rails.handleMethod link
    false

$(document).delegate rails.inputChangeSelector, "change.rails", (e) ->
  link = $(this)
  return rails.stopEverything(e)  unless rails.allowAction(link)
  rails.handleRemote link
  false

$(document).delegate rails.formSubmitSelector, "submit.rails", (e) ->
  form = $(this)
  remote = form.data("remote") isnt `undefined`
  blankRequiredInputs = rails.blankInputs(form, rails.requiredInputSelector)
  nonBlankFileInputs = rails.nonBlankInputs(form, rails.fileInputSelector)
  return rails.stopEverything(e)  unless rails.allowAction(form)
  return rails.stopEverything(e)  if blankRequiredInputs and form.attr("novalidate") is `undefined` and rails.fire(form, "ajax:aborted:required", [ blankRequiredInputs ])
  if remote
    return rails.fire(form, "ajax:aborted:file", [ nonBlankFileInputs ])  if nonBlankFileInputs
    return rails.stopEverything(e)  if not $.support.submitBubbles and $().jquery < "1.7" and rails.callFormSubmitBindings(form, e) is false
    rails.handleRemote form
    false
  else
    setTimeout (->
      rails.disableFormElements form
    ), 13

$(document).delegate rails.formInputClickSelector, "click.rails", (event) ->
  button = $(this)
  return rails.stopEverything(event)  unless rails.allowAction(button)
  name = button.attr("name")
  data = (if name then
    name: name
    value: button.val()
   else null)
  button.closest("form").data "ujs:submit-button", data

$(document).delegate rails.formSubmitSelector, "ajax:beforeSend.rails", (event) ->
  rails.disableFormElements $(this)  if this is event.target

$(document).delegate rails.formSubmitSelector, "ajax:complete.rails", (event) ->
  rails.enableFormElements $(this)  if this is event.target
