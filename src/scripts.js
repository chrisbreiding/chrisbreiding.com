$('.contact-form').on('submit', function (e) {
  e.preventDefault();

  if ($('.processing').length) return;

  $('.contact-form button')
    .after($('<div class="processing">Sending...</div>'))
    .remove();

  setTimeout(function () {
    $form.find('.fields').slideUp(500, function () {
      $form.addClass('success');
    });
  }, 2000);
});
