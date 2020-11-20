class ApplicationController < ActionController::Base
  before_action :ensure_cart # we can guarantee that there is a shopping cart in @cart
  # skip_before_action :ensure_cart, only: [:index] # send to products, there will be definitely be a cart in the system
  def ensure_cart
    @cart = Order.find_by(id: session[:order_id])

    if @cart.nil?
      @cart = Order.make_cart
    end

    if @cart.nil?
      head :internal_server_error
      # have some flash, redirect to homepage
      # make sure the homepage doesn't run cart
    end
  end
end
