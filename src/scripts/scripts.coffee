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
    $inputs = $('.contact-input')

    @$contact = $ '#contact'
    @$contactForm = $('#contact-form').show()
    @inputs = $inputs.map ->
      new Input this

    @addEvents()

  addEvents: ->
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
    reverse = (word)-> word.split('').reverse().join ''

    name = $('#contact-name').val()
    email = $('#contact-email').val()
    message = $('#contact-message').val()

    $.ajax
      type: 'POST'
      dataType: 'JSON'
      url: 'https://mandrillapp.com/api/1.0/messages/send-template.json'
      data:
        key: 'rPNtGh3XdGX45uKEpeZGjA'
        template_name: 'website-contact-form'
        template_content: [
            name: 'contact-name',    content: name
          ,
            name: 'contact-email',   content: email
          ,
            name: 'contact-message', content: message
        ]
        message:
          from_name: name
          from_email: email
          to: [ email: [reverse('gnidierbsirhc'), reverse('moc.liamg')].join('@') ]
      success: (response)=>
        if response.reject_reason
          @showError()
        else
          @close()
      error: (jqXhr)=>
        @showError()

  close: =>
    @$contactForm.slideUp 500, =>
      @$contact.addClass 'success'
      @scrollToBottom()

  showError: ->
    @$contact.addClass 'failure'
    @scrollToBottom()

  scrollToBottom: ->
    $(document.body).animate scrollTop: $(document).height()


new Contact
