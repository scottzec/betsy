# frozen_string_literal: true

class OrderitemsController < ApplicationController
  before_action :require_login, only: [:mark_shipped]
  before_action :find_oi, except: [:create]

  def create
    @cart = Order.find_by(id: session[:order_id])
    product = Product.find_by(id: params[:product_id])
    quantity = params[:orderitem][:quantity].to_i

    # commenting this out - because of ensure_cart in application controller we don't need to check this
    # if @cart.nil?
    #   @cart = Order.new
    #   @cart.status = "pending"
    #   @cart.save
    #   session[:order_id] = @cart.id
    # end

    if product.nil?
      flash[:warning] = 'You must select a valid product'
      redirect_back(fallback_location: root_path)
      return
    end

    if product.merchant.id == session[:user_id]
      flash[:warning] = 'You cannot add your own product to your cart'
      redirect_back(fallback_location: root_path)
      return
    end

    if quantity.nil? || quantity < 1
      flash[:warning] = 'Cannot add 0 items'
      redirect_back(fallback_location: root_path)
      return
    elsif product.stock.zero?
      flash[:warning] = 'Item out of stock, cannot add to cart'
      redirect_back(fallback_location: root_path)
      return
    elsif quantity > product.stock
      flash[:warning] = "Only #{product.stock} items left in stock"
      redirect_back(fallback_location: root_path)
      return
    end

    if @orderitem = @cart.orderitems.find_by(product_id: product.id)
      new_quant = quantity + @orderitem.quantity.to_i
      @orderitem.update(quantity: new_quant)
      flash[:success] = "Successfully updated #{@orderitem.product.name} quantity!"
      redirect_to cart_path
      return
    end

    @orderitem = Orderitem.new
    @orderitem.order_id = @cart.id
    @orderitem.product_id = product.id
    @orderitem.quantity = quantity
    @orderitem.shipped = false


    if @orderitem.save!
      flash[:success] = 'Product successfully added to cart!'
      redirect_to cart_path
      return
    else
      flash[:warning] = 'A problem occurred: could not add item to cart'
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def update
    if @orderitem.nil?
      flash.now[:warning] = 'A problem occurred: could not find item'
      redirect_back(fallback_location: root_path)
      return
    end

    product = Product.find_by(id: @orderitem.product_id)
    name = product.name

    if params[:quantity].to_i > product.stock
      flash[:warning] = "Only #{product.stock} items left in stock"
      redirect_back(fallback_location: root_path)
      return
    end

    if params[:quantity].to_i < 1
      @orderitem.destroy
      flash[:success] = "Removed #{name} from cart"
      redirect_back(fallback_location: root_path)
      return
    end

    if @orderitem.update(quantity: params[:quantity])
      flash[:success] = "Successfully updated #{@orderitem.product.name} quantity!"
      redirect_back(fallback_location: root_path)
      return
    else # save failed :(
      flash[:warning] = "A problem occurred: could not update #{@orderitem.product.name}"
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def destroy
    if @orderitem.nil?
      flash[:warning] = 'A problem occurred: could not locate order item'
      redirect_back(fallback_location: root_path)
      return
    end

    @orderitem.destroy

    flash[:success] = "Successfully removed #{@orderitem.product.name} from cart!"
    redirect_back(fallback_location: root_path)
    return
  end


  def mark_shipped
    if @orderitem.nil?
      flash[:warning] = 'A problem occurred: could not locate order item'
      redirect_back(fallback_location: root_path)
      return
    end

    if @orderitem.shipped == true
      flash[:warning] = 'Product already marked shipped'
      redirect_back(fallback_location: root_path)
      return
    end

    if @orderitem.product.merchant.id != session[:user_id]
      flash[:warning] = 'You cannot ship a product that does not belong to you'
      redirect_back(fallback_location: root_path)
      return
    end

    if @orderitem.order.status != "paid"
      flash[:warning] = 'Order is not confirmed, do not ship product'
      redirect_back(fallback_location: root_path)
      return
    end

    if ! @orderitem.update(shipped: true)
      flash[:warning] = 'A problem occurred: could not update to shipped'
      redirect_back(fallback_location: root_path)
      return
    end


    o1 = @orderitem.order

    if o1.orderitems.find_by(shipped: false).nil?
      o1.status = "complete"
      o1.save
    end

    redirect_back(fallback_location: root_path)
    return
  end


  private

  def find_oi
    @orderitem = Orderitem.find_by(id: params[:id])
  end

end
