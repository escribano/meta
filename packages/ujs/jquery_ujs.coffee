(($, undefined_) ->
  rails = undefined
  $.rails = rails =
    linkClickSelector: "a[data-confirm], a[data-method], a[data-remote], a[data-disable-with]"
    inputChangeSelector: "select[data-remote], input[data-remote], textarea[data-remote]"
    formSubmitSelector: "form"
    formInputClickSelector: "form input[type=submit], form input[type=image], form button[type=submit], form button:not(button[type])"
    disableSelector: "input[data-disable-with], button[data-disable-with], textarea[data-disable-with]"
    enableSelector: "input[data-disable-with]:disabled, button[data-disable-with]:disabled, textarea[data-disable-with]:disabled"
    requiredInputSelector: "input[name][required]:not([disabled]),textarea[name][required]:not([disabled])"
    fileInputSelector: "input:file"
    linkDisableSelector: "a[data-disable-with]"
    CSRFProtection: (xhr) ->
      token = $("meta[name=\"csrf-token\"]").attr("content")
      xhr.setRequestHeader "X-CSRF-Token", token  if token

    fire: (obj, name, data) ->
      event = $.Event(name)
      obj.trigger event, data
      event.result isnt false

    confirm: (message) ->
      confirm message

    ajax: (options) ->
      $.ajax options

    href: (element) ->
      element.attr "href"

    handleRemote: (element) ->
      method = undefined
      url = undefined
      data = undefined
      crossDomain = undefined
      dataType = undefined
      options = undefined
      if rails.fire(element, "ajax:before")
        crossDomain = element.data("cross-domain") or null
        dataType = element.data("type") or ($.ajaxSettings and $.ajaxSettings.dataType)
        if element.is("form")
          method = element.attr("method")
          url = element.attr("action")
          data = element.serializeArray()
          button = element.data("ujs:submit-button")
          if button
            data.push button
            element.data "ujs:submit-button", null
        else if element.is(rails.inputChangeSelector)
          method = element.data("method")
          url = element.data("url")
          data = element.serialize()
          data = data + "&" + element.data("params")  if element.data("params")
        else
          method = element.data("method")
          url = rails.href(element)
          data = element.data("params") or null
        options =
          type: method or "GET"
          data: data
          dataType: dataType
          crossDomain: crossDomain
          beforeSend: (xhr, settings) ->
            xhr.setRequestHeader "accept", "*/*;q=0.5, " + settings.accepts.script  if settings.dataType is `undefined`
            rails.fire element, "ajax:beforeSend", [ xhr, settings ]

          success: (data, status, xhr) ->
            element.trigger "ajax:success", [ data, status, xhr ]

          complete: (xhr, status) ->
            element.trigger "ajax:complete", [ xhr, status ]

          error: (xhr, status, error) ->
            element.trigger "ajax:error", [ xhr, status, error ]

        options.url = url  if url
        rails.ajax options
      else
        false

    handleMethod: (link) ->
      href = rails.href(link)
      method = link.data("method")
      target = link.attr("target")
      csrf_token = $("meta[name=csrf-token]").attr("content")
      csrf_param = $("meta[name=csrf-param]").attr("content")
      form = $("<form method=\"post\" action=\"" + href + "\"></form>")
      metadata_input = "<input name=\"_method\" value=\"" + method + "\" type=\"hidden\" />"
      metadata_input += "<input name=\"" + csrf_param + "\" value=\"" + csrf_token + "\" type=\"hidden\" />"  if csrf_param isnt `undefined` and csrf_token isnt `undefined`
      form.attr "target", target  if target
      form.hide().append(metadata_input).appendTo "body"
      form.submit()

    disableFormElements: (form) ->
      form.find(rails.disableSelector).each ->
        element = $(this)
        method = (if element.is("button") then "html" else "val")
        element.data "ujs:enable-with", element[method]()
        element[method] element.data("disable-with")
        element.prop "disabled", true

    enableFormElements: (form) ->
      form.find(rails.enableSelector).each ->
        element = $(this)
        method = (if element.is("button") then "html" else "val")
        element[method] element.data("ujs:enable-with")  if element.data("ujs:enable-with")
        element.prop "disabled", false

    allowAction: (element) ->
      message = element.data("confirm")
      answer = false
      callback = undefined
      return true  unless message
      if rails.fire(element, "confirm")
        answer = rails.confirm(message)
        callback = rails.fire(element, "confirm:complete", [ answer ])
      answer and callback

    blankInputs: (form, specifiedSelector, nonBlank) ->
      inputs = $()
      input = undefined
      selector = specifiedSelector or "input,textarea"
      form.find(selector).each ->
        input = $(this)
        inputs = inputs.add(input)  if (if nonBlank then input.val() else not input.val())

      (if inputs.length then inputs else false)

    nonBlankInputs: (form, specifiedSelector) ->
      rails.blankInputs form, specifiedSelector, true

    stopEverything: (e) ->
      $(e.target).trigger "ujs:everythingStopped"
      e.stopImmediatePropagation()
      false

    callFormSubmitBindings: (form, event) ->
      events = form.data("events")
      continuePropagation = true
      if events isnt `undefined` and events["submit"] isnt `undefined`
        $.each events["submit"], (i, obj) ->
          continuePropagation = obj.handler(event)  if typeof obj.handler is "function"
      continuePropagation

    disableElement: (element) ->
      element.data "ujs:enable-with", element.html()
      element.html element.data("disable-with")
      element.bind "click.railsDisable", (e) ->
        rails.stopEverything e

    enableElement: (element) ->
      if element.data("ujs:enable-with") isnt `undefined`
        element.html element.data("ujs:enable-with")
        element.data "ujs:enable-with", false
      element.unbind "click.railsDisable"

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
    data = (if name then {name: name, value: button.val()} else null)
    button.closest("form").data "ujs:submit-button", data

  $(document).delegate rails.formSubmitSelector, "ajax:beforeSend.rails", (event) ->
    rails.disableFormElements $(this)  if this is event.target

  $(document).delegate rails.formSubmitSelector, "ajax:complete.rails", (event) ->
    rails.enableFormElements $(this)  if this is event.target
) jQuery
