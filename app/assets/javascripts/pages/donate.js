(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
"use strict";

document.addEventListener('DOMContentLoaded', function (e) {
  var donationBox = document.querySelector('[data-donation-box]');

  if (donationBox) {
    // Token required for header to make post request to the rails backend
    var csrf = document.querySelectorAll('meta[name="csrf-token"]')[0].getAttribute('content');
    var els = {
      amountButtons: [].slice.call(document.querySelectorAll('[data-donation-amount-button]')),
      amountInput: document.querySelector('[data-donation-amount-input]'),
      errorMessage: document.querySelector('[data-donation-error-message]'),
      submitButton: document.querySelector('[data-donation-submit]')
    };
    var methods = {
      init: function init() {
        this.setUpHandlers();

        if (this.isAmountInputEmpty()) {
          this.disableSubmit();
        } else {
          this.enableSubmit();
        }
      },
      disableSubmit: function disableSubmit() {
        els.submitButton.setAttribute('disabled', 'disabled');
      },
      enableSubmit: function enableSubmit() {
        els.submitButton.removeAttribute('disabled');
      },
      isAmountInputEmpty: function isAmountInputEmpty() {
        return els.amountInput.value == '' || els.amountInput.value == 0;
      },
      getRoundedAmount: function getRoundedAmount(amount) {
        return Math.round(amount * 100) / 100;
      },
      getAmountAsFloat: function getAmountAsFloat(amount) {
        return parseFloat(amount * 100);
      },
      makeStripeDonation: function makeStripeDonation() {
        var checkoutSessionID = '';
        var data = {
          amount: this.getAmountAsFloat(els.amountInput.value)
        }; // AJAX

        fetch('/donate/create', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrf
          },
          body: JSON.stringify(data)
        }).then(function (response) {
          return response.json();
        }).then(function (data) {
          if (data.status === "200") {
            els.errorMessage.style.display = 'none'; // https://stripe.com/docs/payments/checkout/one-time
            // Set your publishable key: remember to change this to your live publishable key in production
            // See your keys here: https://dashboard.stripe.com/account/apikeys

            var stripe = Stripe(data.stripe_key);
            checkoutSessionID = data.body.id;
            stripe.redirectToCheckout({
              // Make the id field from the Checkout Session creation API response
              // available to this file, so you can provide it as parameter here
              // instead of the {{CHECKOUT_SESSION_ID}} placeholder.
              sessionId: checkoutSessionID
            }).then(function (result) {
              // If `redirectToCheckout` fails due to a browser or network
              // error, display the localized error message to your customer
              // using `result.error.message`.
              console.error('Error: ', result.error.message);
              handlers.handleError();
            });
          } else {
            console.error('Error:', data.body.error.message);
            handlers.handleError(data.body);
          }
        })["catch"](function (error) {
          console.error('Error:', error);
          handlers.handleError(error);
        });
      },
      setUpHandlers: function setUpHandlers() {
        handlers.amountButtonsHandler();
        handlers.amountInputHandler();
        handlers.submitButtonHandler();
      },
      hideError: function hideError() {
        els.errorMessage.style.display = 'none';
      }
    };
    var handlers = {
      amountButtonsHandler: function amountButtonsHandler() {
        els.amountButtons.forEach(function (button) {
          button.addEventListener('click', function (e) {
            var buttonAmount = e.target.dataset.donationAmount;
            els.amountInput.value = buttonAmount;
            methods.enableSubmit();
            methods.hideError();
          });
        });
      },
      amountInputHandler: function amountInputHandler() {
        els.amountInput.addEventListener('blur', function (e) {
          if (methods.isAmountInputEmpty()) {
            // e.target.removeAttribute('value')
            e.target.setAttribute('placeholder', 'other amount');
          } else {
            e.target.value = methods.getRoundedAmount(e.target.value);
          }
        });
        els.amountInput.addEventListener('change', function (e) {
          els.amountButtons.forEach(function (button) {
            button.previousElementSibling.checked = false;
          });

          if (methods.isAmountInputEmpty()) {
            methods.disableSubmit();
          } else {
            methods.enableSubmit();
          }
        }), els.amountInput.addEventListener('keyup', function (e) {
          if (methods.isAmountInputEmpty()) {
            methods.disableSubmit();
          } else {
            methods.enableSubmit();
          }
        });
      },
      handleError: function handleError(result) {
        if (result.error) {
          els.errorMessage.textContent = result.error.message;
        } else {
          els.errorMessage.textContent = 'Something went wrong.';
        }

        els.errorMessage.style.display = 'block';
      },
      submitButtonHandler: function submitButtonHandler() {
        els.submitButton.addEventListener('click', function (e) {
          e.preventDefault();
          methods.makeStripeDonation();
        });
      }
    };
    methods.init();
  }
});

},{}]},{},[1]);
