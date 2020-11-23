class ApplicationController < ActionController::Base

  before_action :ensure_cart
  # skip_before_action :ensure_cart, only: [:index] # send to products, there will be definitely be a cart in the system
  def ensure_cart
    @cart = Order.find_by(id: session[:order_id])

    if @cart.nil?
      @cart = Order.make_cart
      session[:order_id] = @cart.id
    end

    if @cart.nil?
      flash[:error] = "A problem occurred. The shopping cart could not be found."
      redirect_to root_path
    end

    @cart.status = "pending"
    @cart.save
  end

  # UNCOMMENT FOR OAUTH
  # before_action :require_login

  # def current_merchant
  #   @current_merchant = Merchant.find(session[:user_id])
  # end
  #
  # def require_login
  #   if @current_merchant.nil?
  #     flash[:error] = "You must be logged in to view this section"
  #     redirect_back fallback_location: root_path
  #   end
  # end

end
