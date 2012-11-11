;(function($) {

    var Portfolio = {

        init : function () {
            this.addEvents();
        },

        addEvents : function () {
            $('.port-items')
                .on('click', '.item-more-info', $.proxy(this.reveal, this))
                .on('click', '.item-links', function (e) { e.stopPropagation() });

            $(document.body).on('click', this.hide);
        },

        reveal : function (e) {
            e.preventDefault();
            e.stopPropagation();

            var $parent = $(e.target).closest('.port-item');

            if ( !$parent.hasClass('details-open') ) {
                this.hide();
                $parent.addClass('details-open');
            } else {
                this.hide();
            }
       },

        hide : function () {
            $('.details-open').removeClass('details-open');
        }

    };

    var Contact = {

		init : function () {
            var $inputs = $('.contact-input');

			this.$contactForm = $('#contact-form');
			this.inputs = $inputs.map(function () {
                return new Input(this);
            });

            $inputs.placeholder();

			this.addEvents();
		},

		addEvents : function () {
			this.$contactForm.on('submit', $.proxy(this.onSubmit, this));
		},

		onSubmit : function (e) {
            e.preventDefault();

			if( this.inputsValid() && !$('.processing').length ) {
				this.$contactForm
                    .find('button')
                        .after( $('<div class="processing" />') )
                        .remove();
				this.sendMessage();
			}
		},

		inputsValid : function () {
			var allValid = true;

			this.inputs.each(function () {
                var inputValid = this.validate();

                if ( !inputValid ) {
                    allValid = false;
                }
			});

			return allValid;
		},

        sendMessage : function () {
            $.ajax({
                type : 'POST',
                url : '/send-message',
                data : this.$contactForm.serialize(),
                success : $.proxy( this.close, this)
            });
        },

		close : function (response) {
			this.$contactForm.slideUp(500, $.proxy(function () {
				this.$contactForm
					.after('<div class="response">' + response + '</div')
					.remove();
			}, this));
		}

	};

    var Input = function (el) {
        this.$el = $(el).on('blur', $.proxy(this.onBlur, this));

        this.onBlur();
    };

    Input.prototype = {

        onBlur : function (e) {
            if ( this.isValid() ) this.removeError();
        },

        validate : function () {
            if( !this.isValid() ) {
                this.addError();
                return false;
            }
            return true;
        },

        isValid : function () {
            return this.$el.val() !== '' && this.$el.val() !== this.$el.attr('title');
        },

        addError : function () {
            this.$el.closest('fieldset').addClass('error');
        },

        removeError : function () {
            this.$el.closest('.error').removeClass('error');
        }

    };

    Portfolio.init();
    Contact.init();

}(jQuery));