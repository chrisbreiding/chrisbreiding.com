class Portfolio

  constructor: ->
    @addEvents()

  addEvents: ->
    $('.port-items')
        .on('click', '.item-more-info', @reveal)
        .on('click', '.item-links', (e)-> e.stopPropagation())

    $(document.body).on 'click', @hide

  reveal: (e)=>
    e.preventDefault()
    e.stopPropagation()

    $parent = $(e.target).closest '.port-item'

    if !$parent.hasClass 'details-open'
      @hide()
      $parent.addClass 'details-open'
    else
      @hide()

  hide: ->
    $('.details-open').removeClass 'details-open'


class Input

  constructor: (el)->
    @$el = $(el).on 'blur', @onBlur
    @onBlur()

  onBlur: (e)=>
    @removeError() if @isValid()

  validate: ->
    if !@isValid()
      @addError()
      false
    else
      true

  isValid: ->
    @$el.val() isnt '' and @$el.val() isnt @$el.attr 'title'

  addError: ->
    @$el.closest('fieldset').addClass 'error'

  removeError: ->
    @$el.closest('.error').removeClass 'error'


class Contact

  constructor: ->
    $inputs = $('.contact-input')

    @$contactForm = $('#contact-form').show()
    @inputs = $inputs.map ->
      new Input this

    $inputs.placeholder()

    @addEvents()

  addEvents: ->
    @$contactForm.on 'submit', @onSubmit

  onSubmit: (e)=>
    e.preventDefault()

    if @inputsValid() and !$('.processing').length
      @$contactForm
        .find('button')
        .after($('<div class="processing" />'))
        .remove()
      @sendMessage()

  inputsValid: ->
    allValid = true

    @inputs.each ->
      inputValid = @validate()

      if !inputValid
        allValid = false

      return null

    allValid

  sendMessage: ->
    $.ajax
      dataType: 'JSONP'
      url: 'http://courier.crbapps.com/send'
      data: @$contactForm.serialize()
      success: @close

  close: (response)=>
    @$contactForm.slideUp 500, =>
      @$contactForm
        .after("<div class='response'>#{response}</div")
        .remove()


new Portfolio
new Contact
