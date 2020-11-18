class OrdersController < ApplicationController
  # Purchasing an order makes the following changes:
  # Reduces the number of inventory for each product
  # Changes the order state from "pending" to "paid"
  # Clears the current cart

  # add controller filters, write tests, finish up methods
  # Which custom methods do we need? a checkout method where we either let the user sign in or checkout as guest?
  def cart
    @order = Order.find_by(id: session[:order_id])

    if @order.nil?
      flash[:error] = "No items in shopping cart"
    end
  end

  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end

  # def create
  #   @order = Order.new(order_params)
  #
  #   if @order.save
  #     flash[:success] = "Shopping cart/order created?"
  #     redirect_to root_path
  #     return
  #   else
  #     flash.now[:error] = "A problem occurred. Shopping cart/order not created?"
  #     render :new, status: :bad_request
  #     return
  #   end
  # end

  def show
    @order = Order.find_by(id: params[:id])

    if @order.nil?
      flash[:error] = "Sorry, that order cannot be found"
      redirect_to root_path
      return
    else
      redirect_to order_path(@order.id)
    end
  end

  def edit
    if session[:order_id]
      @order = Order.find_by(id: session[:order_id])
    else
      flash[:error] = "A problem occurred. We couldn't find your order."
      redirect_to root_path
    end
  end

  def update
    @order = Order.find_by(id: session[:order_id])

    if @order.update(order_params)
      flash[:success] = "Your order has been confirmed."
      session[:order_id] = nil
      @order.status = "paid"
      return
    else
      flash[:error] = "A problem occurred. We couldn't complete your order."
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    if @order.nil?
      flash[:error] = "Order cannot be found"
      redirect_to root_path
      return
    end

    if @order.destroy
      flash[:success] = "Your order has been cancelled."
      redirect_to root_path
      return
    end
  end

  private

  def order_params
    return params.require(:order).permit( :status, :name, :email, :address, :credit_card_number, :cvv, :expiration_date, :zip_code, :total)
  end
end
