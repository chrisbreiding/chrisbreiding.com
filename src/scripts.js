(function () {

  var bind = function (obj, fn) {
    return function () { fn.apply(obj, arguments); };
  };

  var reduce = function (arr, acc, fn) {
    for (var i = 0, len = arr.length; i < len; i++) {
      acc = fn(acc, arr[i]);
    }
    return acc;
  }

  var Input = function (el) {
    this.$el = $(el).on('keyup', bind(this, this.checkValidity));
    this.checkValidity();
  };

  Input.prototype = {

    checkValidity: function () {
      if (this.isValid()) this.removeError();
    },

    isValid: function () {
      return this.$el.val() !== '';
    },

    addError: function () {
      this.$el.closest('fieldset').addClass('error');
    },

    removeError: function () {
      this.$el.closest('.error').removeClass('error');
    }

  };

  var Contact = function () {
    this.$contact = $('#contact');
    this.$contactForm = $('#contact-form');
    this.inputs = $('.contact-input').map(function () {
      return new Input(this);
    });

    this.$contactForm.on('submit', bind(this, this.onSubmit));
  };

  Contact.prototype = {

    onSubmit: function (e) {
      e.preventDefault();

      if ($('.processing').length || !this.inputsValid()) return;

      this.$contactForm
        .find('button')
        .after($('<div class="processing">Sending...</div>'))
        .remove();
      this.sendMessage();
    },

    inputsValid: function () {
      return reduce(this.inputs, true, function (allValid, input) {
        if (!input.isValid()) {
          allValid = false;
          input.addError();
        }
        return allValid;
      });
    },

    sendMessage: function () {
      $.ajax({
        type: 'POST',
        dataType: 'JSON',
        url: 'http://courier.crbapps.com',
        data: this.$contactForm.serialize(),
        success: bind(this, function (response) {
          if (response.reject_reason) {
            this.showError();
          } else {
            this.close();
          }
        }),
        error: bind(this, function () {
          this.showError();
        })
      });
    },

    close: function () {
      this.$contactForm.slideUp(500, bind(this, function () {
        this.$contact.addClass('success');
        this.scrollToBottom();
      }));
    },

    showError: function () {
      this.$contact.addClass('failure');
      this.scrollToBottom();
    },

    scrollToBottom: function () {
      $(document.body).animate({ scrollTop: '' + $(document).height() + 'px' });
    }

  };

  new Contact();

}());

(function () {
  window._gaq = [
    ['_setAccount', 'UA-30345162-1'],
    ['_trackPageview']
  ];
  var ga = document.createElement('script');
  ga.type = 'text/javascript';
  ga.async = true;
  ga.src = 'http://www.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(ga, s);
}());
