// Using Browserify to import Javascript modules
import Promise from 'promise-polyfill'

window.addEventListener('DOMContentLoaded', (e) => {
  // https://stripe.com/docs/payments/checkout/one-time
  // Set your publishable key: remember to change this to your live publishable key in production
  // See your keys here: https://dashboard.stripe.com/account/apikeys
  var stripe = Stripe('pk_test_GFYnuAzbarGYpqEhChkf0ArP00vM4CsJft')
  // Token required for header to make post request to the rails backend
  const csrf = document.querySelectorAll('meta[name="csrf-token"]')[0].getAttribute('content')

  const els = {
    amountButtons: [].slice.call(document.querySelectorAll('[data-donation-amount-button]')),
    amountInput: document.querySelector('[data-donation-amount-input]'),
    submitButton: document.querySelector('[data-donation-submit]')
  }

  const methods = {
    init: function () {
      this.setUpHandlers()
    },
    getRoundedAmount: function (amount) {
      return Math.round(amount * 100) / 100
    },
    getAmountAsFloat: function (amount) {
      return parseFloat(amount * 100)
    },
    makeStripeDonation: function () {
      let checkoutSessionID = ''
      const data = { amount: this.getAmountAsFloat(els.amountInput.value) }

      // AJAX
      fetch('/donate/create', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrf
        },
        body: JSON.stringify(data),
      })
      .then((response) => response.json())
      .then((data) => {
        alert('Success!')
        console.log('Success:', data)
        checkoutSessionID = data.id
        stripe.redirectToCheckout({
          // Make the id field from the Checkout Session creation API response
          // available to this file, so you can provide it as parameter here
          // instead of the {{CHECKOUT_SESSION_ID}} placeholder.
          sessionId: checkoutSessionID
        }).then(function (result) {
          // If `redirectToCheckout` fails due to a browser or network
          // error, display the localized error message to your customer
          // using `result.error.message`.
          console.log(result);
          console.error('Error: ', result.error.message)
        })
      })
      .catch((error) => {
        alert('Error!')
        console.error('Error:', error)
      })
    },
    setUpHandlers: function () {
      handlers.amountButtonsHandler()
      handlers.amountInputHandler()
      handlers.submitButtonHandler()
    }
  }

  const handlers = {
    amountButtonsHandler: function () {
      els.amountButtons.forEach((button) => {
        button.addEventListener('click', (e) => {
          const buttonAmount = e.target.dataset.donationAmount
          els.amountInput.value = buttonAmount
          els.submitButton.removeAttribute('disabled')
          els.submitButton.classList.remove('error')
        })
      })
    },
    amountInputHandler: function () {
      els.amountInput.addEventListener('blur', (e) => {
        e.target.value = methods.getRoundedAmount(e.target.value)
      })
      els.amountInput.addEventListener('change', (e) => {
        els.amountButtons.forEach((button) => {
          button.previousElementSibling.checked = false
        })
        if (e.target.value == '' || e.target.value == 0) {
          els.submitButton.setAttribute('disabled', 'disabled')
          els.submitButton.classList.add('error')
        } else {
          els.submitButton.removeAttribute('disabled')
        }
      })
    },
    submitButtonHandler: function () {
      els.submitButton.addEventListener('click', (e) => {
        e.preventDefault()

        if (els.amountInput.value == '') {
          alert('Amount is empty!')
        } else {
          methods.makeStripeDonation()
        }
      })
    }
  }

  methods.init()
})
