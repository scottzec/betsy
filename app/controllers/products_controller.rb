class ProductsController < ApplicationController
  skip_before_action :require_login, except: [:new, :create, :edit, :update, :destroy]
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    # @current_merchant won't be nil bc require_login would have otherwise redirected us
    # creates a product with product params that belongs to the current_merchant
    @product = @current_merchant.products.new(product_params)

    if @product.save # returns true if db insert succeeds
      flash[:success] = "Your #{@product.name} has been added successfully to the catalog"
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:warning] = "Something's gone awry. Your listing hasn't been created"
      render :new, status: :bad_request
      return
    end
  end

  def show
    if @product.nil?
      redirect_to products_path
    end
  end

  def edit
    if @product.nil?
      head :not_found
      return
    end
  end

  def update
    # @product.merchant already exists in the listing that is being updated, can just call that and don't need to define it
    if @product.nil?
      flash[:warning] = "Product not found"
      redirect_to root_path
      return
    end

    # Current merchant will already be populated (app_controller). Just have to check that the current_merchant is the same as the owner of the product
    unless @product.merchant == @current_merchant
      flash[:warning] = "This product doesn't belong to you. Hands off"
      redirect_to root_path
      return
    end

    # If there aren't any categories in the params, then reverse merge an empty array to supersede the existing categories if update is 0 categories
    if @product.update(product_params.reverse_merge(categories: []))
      flash[:success] = "Your #{@product.name} has been updated"
      redirect_to dashboard_path
      return
    else

      flash.now[:warning] = "There was a problem. We couldn't update your listing"
      render :edit
      return

    end
  end

  def destroy
    if @product.nil?
      head :not_found
      return
    end

    @product.destroy
    flash[:success] = "Your product listing #{@product.name} has now been deleted"
    redirect_to products_path
    return
  end

  private

  def product_params
    return params.require(:product).permit(:name, :description, :price, :photo_url, :stock, :merchant_id, category_ids: [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
  end

end
