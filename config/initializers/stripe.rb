Rails.configuration.stripe = {
  publishable_key: 'pk_test_GFYnuAzbarGYpqEhChkf0ArP00vM4CsJft',
  secret_key:      'sk_test_bEYLlmqQa77A6QNdxHURFADg00q55Dcpr3'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
