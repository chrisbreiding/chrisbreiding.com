(function() {
  var Contact, Input, Portfolio,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Portfolio = (function() {

    function Portfolio() {
      this.reveal = __bind(this.reveal, this);
      this.addEvents();
    }

    Portfolio.prototype.addEvents = function() {
      $('.port-items').on('click', '.item-more-info', this.reveal).on('click', '.item-links', function(e) {
        return e.stopPropagation();
      });
      return $(document.body).on('click', this.hide);
    };

    Portfolio.prototype.reveal = function(e) {
      var $parent;
      e.preventDefault();
      e.stopPropagation();
      $parent = $(e.target).closest('.port-item');
      if (!$parent.hasClass('details-open')) {
        this.hide();
        return $parent.addClass('details-open');
      } else {
        return this.hide();
      }
    };

    Portfolio.prototype.hide = function() {
      return $('.details-open').removeClass('details-open');
    };

    return Portfolio;

  })();

  Input = (function() {

    function Input(el) {
      this.onBlur = __bind(this.onBlur, this);
      this.$el = $(el).on('blur', this.onBlur);
      this.onBlur();
    }

    Input.prototype.onBlur = function(e) {
      if (this.isValid()) {
        return this.removeError();
      }
    };

    Input.prototype.validate = function() {
      if (!this.isValid()) {
        this.addError();
        return false;
      } else {
        return true;
      }
    };

    Input.prototype.isValid = function() {
      return this.$el.val() !== '' && this.$el.val() !== this.$el.attr('title');
    };

    Input.prototype.addError = function() {
      return this.$el.closest('fieldset').addClass('error');
    };

    Input.prototype.removeError = function() {
      return this.$el.closest('.error').removeClass('error');
    };

    return Input;

  })();

  Contact = (function() {

    function Contact() {
      this.close = __bind(this.close, this);

      this.onSubmit = __bind(this.onSubmit, this);

      var $inputs;
      $inputs = $('.contact-input');
      this.$contactForm = $('#contact-form');
      this.inputs = $inputs.map(function() {
        return new Input(this);
      });
      $inputs.placeholder();
      this.addEvents();
    }

    Contact.prototype.addEvents = function() {
      return this.$contactForm.on('submit', this.onSubmit);
    };

    Contact.prototype.onSubmit = function(e) {
      e.preventDefault();
      if (this.inputsValid() && !$('.processing').length) {
        this.$contactForm.find('button').after($('<div class="processing" />')).remove();
        return this.sendMessage();
      }
    };

    Contact.prototype.inputsValid = function() {
      var allValid;
      allValid = true;
      this.inputs.each(function() {
        var inputValid;
        inputValid = this.validate();
        if (!inputValid) {
          allValid = false;
        }
        return null;
      });
      return allValid;
    };

    Contact.prototype.sendMessage = function() {
      return $.ajax({
        type: 'POST',
        url: 'http://courier.crbapps.com/send',
        data: this.$contactForm.serialize(),
        success: this.close
      });
    };

    Contact.prototype.close = function(response) {
      var _this = this;
      return this.$contactForm.slideUp(500, function() {
        return _this.$contactForm.after("<div class='response'>" + response + "</div").remove();
      });
    };

    return Contact;

  })();

  new Portfolio;

  new Contact;

}).call(this);
