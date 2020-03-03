class CheckoutsController < ApplicationController

  def create
    render json: create_session(params['amount'])
  end

  def create_session amount
    # Set your secret key. Remember to switch to your live secret key in production!
    # See your keys here: https://dashboard.stripe.com/account/apikeys
    Stripe.api_key = 'sk_test_bEYLlmqQa77A6QNdxHURFADg00q55Dcpr3'
    session = Stripe::Checkout::Session.create(
      submit_type: 'donate',
      payment_method_types: ['card'],
      line_items: [{
        name: 'Donation',
        description: 'Donation to UNEP-WCMC',
        amount: amount,
        currency: 'gbp',
        quantity: 1
      }],
      success_url: 'https://example.com/success?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: 'https://google.co.uk'
    )
    { body: session, status: '200' }
  rescue Stripe::InvalidRequestError => e
    { body: e.json_body, status: e.http_status }
  end
end
