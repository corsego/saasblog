class CheckoutController < ApplicationController
  
  def create
    @session = Stripe::Checkout::Session.create({
      success_url: posts_url,
      cancel_url: pricing_url,
      payment_method_types: ['card'],
      line_items: [
        {price: 'price_1IUDb0AkDVZc6qQweqsS6ATK', quantity: 1},
      ],
      mode: 'subscription',
    })
    respond_to do |format|
      format.js
    end
  end
  
end