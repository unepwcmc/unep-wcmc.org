class CheckoutsController < ApplicationController

  def create
    render json: create_session(params['amount'])
  end

  def create_session amount
    # Set your secret key. Remember to switch to your live secret key in production!
    # See your keys here: https://dashboard.stripe.com/account/apikeys
    session = Stripe::Checkout::Session.create(
      submit_type: 'donate',
      payment_method_types: ['card'],
      line_items: [{
        name: 'Donation',
        description: 'Donation to UNEP-WCMC',
        images: ['https://p2.piqsels.com/preview/1014/551/768/frog-green-lilypad-eyes.jpg'],
        amount: amount,
        currency: 'gbp',
        quantity: 1
      }],
      success_url: request.base_url + '/donate/success',
      cancel_url: request.base_url + '/donate'
    )
    { body: session, status: '200', stripe_key: Rails.application.secrets.stripe_public_key }
  rescue Stripe::InvalidRequestError => e
    { body: e.json_body, status: e.http_status }
  end
end
