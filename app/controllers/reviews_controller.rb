class ReviewsController < ApplicationController
  def new
    if params[:product_id]
      @product = Product.find_by(id: params[:product_id])
      # the page is still accessible, for those tricky merchants that try to find the page manually
      if(!session[:user_id].nil? && session[:user_id] == @product.merchant_id)
        flash[:warning] = "you can't review your own product!"
        redirect_back fallback_location: product_path(@product.id)
      end
    else
      flash[:warning] = "no product found -- cannot leave a review"
      redirect_back fallback_location: root_path
    end
  end

  def create
    @review = Review.new(review_params)
    if @cat.save
      flash[:success] = "successfully created new category #{@cat.name}"
      redirect_to dashboard_path
    else
      render :new, status: :bad_request
    end
    return
  end

  private

  def merchant_params
    return params.require(:merchant).permit(:rating, :review)
  end
end
