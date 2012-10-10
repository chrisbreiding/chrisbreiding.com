;(function($) {

	var Slider = {

		init : function () {
			this.$slider = $('.slider');
			this.numSlides = this.$slider.find('li').length;
			this.currentSlideIndex = 1;

			this.createNav();
			this.run();
		},

		createNav : function () {
			$('<ul />', {
				html : $('.slides')
							.find('li')
							.clone()
							.each(function (i) {
								$(this).data('slide', i + 1);
							})
			})
			.addClass('slider-nav')
			.appendTo( this.$slider );

			$('.slide-1').addClass('active');

			this.addEvents();
		},

		addEvents : function () {
			var self = this;

			this.$slider.on('click', '.slider-nav li', function () {
				self.switchSlide.call(self, this, true);
			});
		},

		switchSlide : function (el, manual) {
			var $el = $(el),
				slideIndex = $el.data('slide'),
				$slide = $( '.slides .slide-' + slideIndex),
				timing = manual ? 500 : 1000;

			if( !$slide.hasClass('active') ) {

				if(manual) clearTimeout(this.sliderTimeout);

				$('.slides .active').fadeOut(timing).removeClass('active');
				$slide.fadeIn(timing).addClass('active');

				$('.slider-nav .active').removeClass('active');
				$el.addClass('active');

				this.currentSlideIndex = slideIndex > (this.numSlides - 1) ? 0 : slideIndex;

				if(manual) this.run();

			}
		},

		run : function () {
			var nextSlideNav = $('.slider-nav .slide-' + (this.currentSlideIndex + 1)).get(0);

			this.sliderTimeout = setTimeout($.proxy(function () {
				this.switchSlide(nextSlideNav);
				this.run();
			}, this), 4000);
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

			// gonna be lazy and just make sure it's not blank
			this.inputs.each(function () {
                var inputValid = this.validate();

                if ( !inputValid ) {
                    allValid = false;
                }
			});

			return allValid;
		},

        errorTemplate : function (error) {
            return '<div class="error-message">Please enter ' + error + '.</div>';
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
					.after(response)
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
            var name = this.$el.attr('name'),
                error = (name === "message" ? ' a ' : ' your ') + name;

            this.$el.closest('fieldset')
                .addClass('error')
                .append( Contact.errorTemplate(error) );
        },

        removeError : function () {
            this.$el
                .closest('.error')
                    .removeClass('error')
                        .find('.error-message')
                            .remove();
        }

    };

	Slider.init();
    Contact.init();

}(jQuery));