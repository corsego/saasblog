# [App demo](https://saasblog.herokuapp.com/)

****

credentials
```
stripe:
  secret: sk_test_
  public: pk_test_
  webhook: whsec_
```
create stripe product
```
Stripe::Product.create(name: 'starter')
```
create stripe price
```
Stripe::Price.create(
  product: 'prod_xxx',
  unit_amount: 500,
  currency: 'usd',
  recurring: {
    interval: 'month'
  },
  lookup_key: 'starter',
)
```
add to button links for impression of faster loading
```
, data: { disable_with: "Connecting..." }
```
sort prices by amount
```
def pricing
  @prices = Stripe::Price.list().data.sort_by {|p| p.unit_amount}
end
```  
option to find price by lookup_key - checkout_controller
```
price = Stripe::Price.list(lookup_keys: [params[:plan]]).data.first
```
option to find price by lookup_key - view
```
<%= button_to checkout_create_path(plan: price.lookup_key), remote: true, data: { disable_with: "Connecting..." } do %>
```
styling post views
```
<td><%= truncate(post.content, length: 17) %></td>
<%= simple_format(@post.content) %>
```
## webhooks
routes
```
resources :webhooks, only: [:create]
```
webhooks_controller.rb
```
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
    when 'checkout.session.completed'
      session = event.data.object
      @user = User.find_by(stripe_customer_id: session.customer)
      @user.update(subscription_status: 'active')
    when 'customer.subscription.updated', 'customer.subscription.deleted'
      subscription = event.data.object
      @user = User.find_by(stripe_customer_id: subscription.customer)
      @user.update(
        subscription_status: subscription.status,
        plan: subscription.items.data[0].price.lookup_key,
      )
    end

    render json: { message: 'success' }
  end
end
```
## stripe CLI
[https://stripe.com/docs/stripe-cli](https://stripe.com/docs/stripe-cli)
```
stripe listen
stripe logs tail 
stripe trigger payment_intent.succeeded
stripe customers create
stripe listen --forward-to localhost:3000/webhooks
```
