const form = document.querySelector('form')
const message = document.querySelector('textarea')

form.addEventListener('submit', (e) => {
  e.preventDefault()

  if (form.classList.contains('sending')) return

  form.classList.add('sending')

  const formData = new FormData(form)

  fetch('/', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: new URLSearchParams(formData).toString()
  })
  .then((res) => {
    if (!res.ok) {
      throw new Error(`${res.status} ${res.statusText}`)
    }

    form.classList.add('success')
  })
  .catch((error) => {
    console.error('Error submitting contact form:', error)

    form.classList.add('failure')
  })
})

function checkFormValidity () {
  const isValid = message.value?.trim().length > 0

  if (isValid) {
    form.classList.remove('invalid')
  } else {
    form.classList.add('invalid')
  }
}

message.addEventListener('keyup', checkFormValidity)

checkFormValidity()
