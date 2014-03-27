class Input

  constructor: (el)->
    @$el = $(el).on 'keyup', @checkValidity
    @checkValidity()

  checkValidity: =>
    @removeError() if @isValid()

  validate: ->
    isValid = @isValid()
    @addError() unless isValid
    isValid

  isValid: ->
    @$el.val() isnt ''

  addError: ->
    @$el.closest('fieldset').addClass 'error'

  removeError: ->
    @$el.closest('.error').removeClass 'error'


class Contact

  constructor: ->
    @$contact = $ '#contact'
    @$contactForm = $ '#contact-form'
    @inputs = $('.contact-input').map ->
      new Input this

    @$contactForm.on 'submit', @onSubmit

  onSubmit: (e)=>
    e.preventDefault()

    if @inputsValid() and !$('.processing').length
      @$contactForm
        .find('button')
        .after($('<div class="processing">Sending...</div>'))
        .remove()
      @sendMessage()

  inputsValid: ->
    allValid = true

    for input in @inputs
      allValid = false unless input.validate()

    allValid

  sendMessage: ->
    $.ajax
      type: 'POST'
      dataType: 'JSON'
      url: 'http://courier.crbapps.com'
      data: @$contactForm.serialize()
      success: (response)=>
        if response.reject_reason
          @showError()
        else
          @close()
      error: =>
        @showError()

  close: =>
    @$contactForm.slideUp 500, =>
      @$contact.addClass 'success'
      @scrollToBottom()

  showError: ->
    @$contact.addClass 'failure'
    @scrollToBottom()

  scrollToBottom: ->
    $(document.body).animate scrollTop: "#{$(document).height()}px"


new Contact


# google analytics

window._gaq = [
  ['_setAccount', 'UA-30345162-1']
  ['_trackPageview']
]
ga = document.createElement 'script'
ga.type = 'text/javascript'
ga.async = true
ga.src = 'http://www.google-analytics.com/ga.js'
s = document.getElementsByTagName('script')[0]
s.parentNode.insertBefore ga, s
