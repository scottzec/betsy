class OrdersController < ApplicationController
  # before_action :require_login, only: [:merchant_show]

  before_action :find_cart, only: [:cart, :checkout, :edit, :update]

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

    # we are looking at an order that the merchant has products in
    @orderitems = @order.filter_order_items(@current_merchant) # use orderitems in the view for collection of items

    if @orderitems.empty?
      flash[:error] = "You do not have products in this order"
      redirect_to root_path # redirect to merchant's dashboard
      return
    end
  end

  def edit; end # the final checkout

  def checkout # this was checkout
    if @cart.update(order_params)
      @cart.checkout
      flash[:success] = "Your order has been confirmed."
      session[:order_id] = nil
      redirect_to order_path(@cart.id)
      return
    else
      flash[:error] = "A problem occurred. We couldn't complete your order."
      render :edit, status: :bad_request
      return
    end
  end

  #
  # def update # original update
  #   if @cart.update(order_params)
  #     flash[:success] = "Your order info has been updated."
  #     redirect_to root_path
  #     return
  #   else
  #     flash[:error] = "A problem occurred. We couldn't update your order."
  #     render :edit, status: :bad_request
  #     return
  #   end
  # end

  # def update # moves cart status NOT NEEDED, KEEPING AS A COMMENT FOR NOW
  #   if @cart.update(order_params) && @cart.checkout
  #     flash[:success] = "Your order has been confirmed."
  #     session[:order_id] = nil
  #     redirect_to order_path(@cart.id)
  #     return
  #   else
  #     flash[:error] = "A problem occurred. We couldn't complete your order."
  #     render :edit, status: :bad_request
  #     return
  #   end
  # end

    # def cancel
    #   if @order.update(status: "cancelled")
        # flash[:success] = "Order successfully cancelled."
    #   # restore the stock
    #   # no part of the order has been fulfilled - order items on merchant dashboard
    #   # complete once all order items have been filled
    # end

  def destroy
    if @cart.update(status: "cancelled") && @cart.can_cancel
       flash[:success] = "Order successfully cancelled."
       @cart.destroy
       session[:order_id] = nil
       redirect_to products_path
       return
    else
      flash[:error] = "A problem occurred. Your order has already shipped - you may delete any items that haven't been shipped."
      render :edit, status: :bad_request
      return
    end
  end

  # def complete # once the user pays for it they can't see it anymore
  #   # this needs login, merchant needs to login to mark order complete
  #   # if you have an order page
  #   if @cart.complete
  #     @cart.update(status: "complete")
  #     flash[:success] = "Order is complete"
  #
  #   else
  #     # there shouldn't be a reason for someone to end up here, but if they do something really wrong happened
  #     flash[:error] = "A problem occurred. Other people haven't finished shipping this item."
  #     # render :edit, status: :bad_request
  #     redirect_to dashboard_path
  #     return
  #   end
  #
  #
  #   # if @cart.update(status: "complete") && @cart.complete
  #   #   flash[:success] = "Order is complete"
  #   #   session[:order_id] = nil
  #   #   redirect_to order_path(@cart.id)
  #   #   return
  #   # else
  #   #   flash[:error] = "A problem occurred. We couldn't complete your order."
  #   #   # render :edit, status: :bad_request
  #   #   return
  #   end
  # end

  private

  def order_params
    return params.require(:order).permit( :status, :name, :email, :address, :credit_card_number, :cvv, :expiration_date, :zip_code)
  end

  def find_cart
    @cart = Order.find_by(id: session[:order_id])
  end
end
