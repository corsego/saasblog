class WebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.application.credentials.dig(:stripe, :webhook)
      )
    rescue JSON::ParserError => e
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      puts "Signature error"
      p e
      return
    end

    # Handle the event
    case event.type
    when 'customer.created'
      customer = event.data.object
      @user = User.find_by(email: customer.email)
      @user.update(stripe_customer_id: customer.id)
    when 'customer.subscription.updated', 'customer.subscription.deleted', 'customer.subscription.created'
      subscription = event.data.object
      @user = User.find_by(stripe_customer_id: subscription.customer)
      @user.update(
        subscription_status: subscription.status,
        plan: subscription.items.data[0].price.lookup_key,
        current_period_end: Time.at(subscription.current_period_end).to_datetime,
      )
    end

    render json: { message: 'success' }
  end
end
