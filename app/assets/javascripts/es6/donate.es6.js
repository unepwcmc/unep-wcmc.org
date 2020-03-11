document.addEventListener('DOMContentLoaded', (e) => {
  const donationBox = document.querySelector('[data-donation-box]')

  if (donationBox) {
    // Token required for header to make post request to the rails backend
    const csrf = document.querySelectorAll('meta[name="csrf-token"]')[0].getAttribute('content')

    const els = {
      amountButtons: [].slice.call(document.querySelectorAll('[data-donation-amount-button]')),
      amountInput: document.querySelector('[data-donation-amount-input]'),
      errorMessage: document.querySelector('[data-donation-error-message]'),
      submitButton: document.querySelector('[data-donation-submit]')
    }

    const methods = {
      init: function () {
        this.setUpHandlers()
        if (this.isAmountInputEmpty()) {
          this.disableSubmit()
        } else {
          this.enableSubmit()
        }
      },
      disableSubmit: function () {
        els.submitButton.setAttribute('disabled', 'disabled')
      },
      enableSubmit: function () {
        els.submitButton.removeAttribute('disabled')
      },
      isAmountInputEmpty: function() {
        return els.amountInput.value == '' || els.amountInput.value == 0
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
          if (data.status === "200") {
            els.errorMessage.style.display = 'none';
            // https://stripe.com/docs/payments/checkout/one-time
            // Set your publishable key: remember to change this to your live publishable key in production
            // See your keys here: https://dashboard.stripe.com/account/apikeys
            var stripe = Stripe(data.stripe_key)
            checkoutSessionID = data.body.id
            stripe.redirectToCheckout({
              // Make the id field from the Checkout Session creation API response
              // available to this file, so you can provide it as parameter here
              // instead of the {{CHECKOUT_SESSION_ID}} placeholder.
              sessionId: checkoutSessionID
            }).then(function (result) {
              // If `redirectToCheckout` fails due to a browser or network
              // error, display the localized error message to your customer
              // using `result.error.message`.
              console.error('Error: ', result.error.message)
              handlers.handleError()
            })
          } else {
            console.error('Error:', data.body.error.message)
            handlers.handleError(data.body)
          }
        })
        .catch((error) => {
          console.error('Error:', error)
          handlers.handleError(error)
        })
      },
      setUpHandlers: function () {
        handlers.amountButtonsHandler()
        handlers.amountInputHandler()
        handlers.submitButtonHandler()
      },
      hideError: function () {
        els.errorMessage.style.display = 'none'
      }
    }

    const handlers = {
      amountButtonsHandler: function () {
        els.amountButtons.forEach((button) => {
          button.addEventListener('click', (e) => {
            const buttonAmount = e.target.dataset.donationAmount
            els.amountInput.value = buttonAmount
            methods.enableSubmit()
            methods.hideError()
          })
        })
      },
      amountInputHandler: function () {
        els.amountInput.addEventListener('blur', (e) => {
          if (methods.isAmountInputEmpty()) {
            // e.target.removeAttribute('value')
            e.target.setAttribute('placeholder', 'other amount')
          } else {
            e.target.value = methods.getRoundedAmount(e.target.value)
          }
        })
        els.amountInput.addEventListener('change', (e) => {
          els.amountButtons.forEach((button) => {
            button.previousElementSibling.checked = false
          })
          if (methods.isAmountInputEmpty()) {
            methods.disableSubmit()
          } else {
            methods.enableSubmit()
          }
        }),
        els.amountInput.addEventListener('keyup', (e) => {
          if (methods.isAmountInputEmpty()) {
            methods.disableSubmit()
          } else {
            methods.enableSubmit()
          }
        })
      },
      handleError: function(result) {
        if (result.error) {
          els.errorMessage.textContent = result.error.message;
        } else {
          els.errorMessage.textContent = 'Something went wrong.';
        }
        els.errorMessage.style.display = 'block'
      },
      submitButtonHandler: function () {
        els.submitButton.addEventListener('click', (e) => {
          e.preventDefault()
          methods.makeStripeDonation()
        })
      }
    }

    methods.init()
  }
})
