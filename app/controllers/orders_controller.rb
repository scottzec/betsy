class OrdersController < ApplicationController
  before_action :require_login, only: [:merchant_show]

  def cart; end

  def show # this is order confirmation
    @order = Order.find_by(id: params[:id])

    if @order.nil?
      flash[:error] = "Sorry, that order cannot be found"
      redirect_to root_path
      return
    end
  end

  def merchant_show
    @order = Order.find_by(id: params[:id])
    @current_merchant = Merchant.find_by(id: session[:user_id])

    if @order.nil?
      flash[:error] = "Sorry, that order cannot be found"
      redirect_to root_path
      return
    end

    if @current_merchant.nil?
      flash[:error] = "Users must be logged in for this functionality"
      redirect_to root_path
      return
    end

    # We are looking at an order that the merchant has products in
    @orderitems = @order.filter_order_items(@current_merchant) 

    if @orderitems.empty?
      flash[:error] = "You do not have products in this order"
      redirect_to dashboard_path 
      return
    end
  end

  def edit; end

  def checkout
    if @cart.update(order_params) && @cart.checkout
      flash[:success] = "Your order has been confirmed."
      session[:order_id] = nil
      redirect_to order_path(@cart.id)
      return
    else
      flash.now[:errors] = @cart.errors.messages
      render :cart, status: :bad_request
      return
    end
  end

  def destroy
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:error] = "Order couldn't be found"
      redirect_to root_path
      return
    elsif @order.cancel
       flash[:success] = "Order #{@order.id} successfully cancelled."
       redirect_to order_path(@order.id)
       return
    else
      flash[:error] = "A problem occurred. Your order could not be cancelled."
      redirect_to order_path(@order.id)
      return
    end
  end

  private

  def order_params
    return params.require(:order).permit(:status, :name, :email, :address, :credit_card_number, :cvv, :expiration_date, :zip_code)
  end
end

