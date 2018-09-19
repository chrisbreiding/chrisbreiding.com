(function () {
  const form = document.querySelector('.contact-form')

  form.addEventListener('submit', function (e) {
    e.preventDefault()

    if (form.classList.contains('sending')) return

    form.classList.add('sending')

    setTimeout(function () {
      form.classList.add('success')
    }, 2000)
  })
}())