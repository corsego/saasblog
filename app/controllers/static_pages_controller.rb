class StaticPagesController < ApplicationController
  
  def pricing
    @pricing = Stripe::Price.list(lookup_keys: ["good_year", "good_month"], expand: ["data.product"]).data.sort_by {|p| p.unit_amount}
  end
  
end