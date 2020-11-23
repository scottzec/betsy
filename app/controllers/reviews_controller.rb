class ReviewsController < ApplicationController
  skip_before_action :require_login
  def new
    if !Product.find_by(id:params[:product_id]).nil?
      @product = Product.find_by(id: params[:product_id])
      @merchant = Merchant.find_by(id: @product.merchant_id)
      # the page is still accessible, for those tricky merchants that try to find the page manually
      if(!session[:user_id].nil? && session[:user_id] == @product.merchant_id)
        flash[:warning] = "you can't review your own product!"
        redirect_to product_path(@product.id)
      end
      @review = @product.reviews.new
    else
      flash[:warning] = "no product found - feel free to review our other products below!"
      redirect_to root_path
    end
  end

  def create
    if !Product.find_by(id: params[:product_id]).nil?
      @product = Product.find_by(id: params[:product_id])
      @merchant = Merchant.find_by(id: @product.merchant_id)
      # the page is still accessible, for those tricky merchants that try to find the page manually
      if(!session[:user_id].nil? && session[:user_id] == @product.merchant_id)
        flash[:warning] = "you can't review your own product!"
        redirect_to product_path(@product.id)
        return
      end
      @review = @product.reviews.new(review_params)
      if @review.save
        flash[:success] = "successfully left review of #{@product.name} by #{@merchant.username}"
        redirect_to product_path(@product.id)
      else
        flash[:error] = @review.errors.messages
        render :new, status: :bad_request
      end
    else
      flash[:warning] = "no product found - feel free to review our other products below!"
      redirect_to root_path
    end
    return
  end

  private

  def review_params
    return params.require(:review).permit(:rating, :review)
  end

  def get_merchant_and_product
    if !Product.find_by(id: params[:product_id]).nil?
      @product = Product.find_by(id: params[:product_id])
      @merchant = Merchant.find_by(id: @product.merchant_id)
      if(!session[:user_id].nil? && session[:user_id] == @product.merchant_id)
        flash[:warning] = "you can't review your own product!"
        redirect_to product_path(@product.id)
        return
      end
    else
      flash[:warning] = "no product found - feel free to review our other products below!"
      redirect_to root_path
      return
    end
  end
end
