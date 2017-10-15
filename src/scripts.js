(function () {

  var slice = Array.prototype.slice;

  var partial = function (fn) {
    var args = slice.call(arguments, 1);
    return function () {
      fn.apply(this, args.concat(slice.call(arguments)));
    };
  };

  var isValid = function ($input) {
    return $input.val() !== '';
  };

  var checkValidity = function ($input, $form) {
    var action = isValid($input) ? 'removeClass' : 'addClass';
    $form[action]('invalid');
  };

  var closeForm = function ($form, success) {
    $form.find('.fields').slideUp(500, function () {
      $form.addClass(success ? 'success' : 'failure');
    });
  };

  var sendMessage = function ($form) {
    $.post($form.attr('action'), $form.serialize())
    .then(function (response) {
      closeForm($form, !response.reject_reason);
    })
    .catch(function () {
      closeForm($form, false);
    })
  };

  var onSubmit = function ($form, $message, e) {
    e.preventDefault();

    if ($('.processing').length || !isValid($message)) return;

    $form
      .find('button')
      .after($('<div class="processing">Sending...</div>'))
      .remove();
    sendMessage($form);
  };

  var $contactForm = $('.contact-form');
  var $message = $('.message');
  $contactForm.on('submit', partial(onSubmit, $contactForm, $message));
  $message.on('keyup', partial(checkValidity, $message, $contactForm));

}());
