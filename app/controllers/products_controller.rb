class ProductsController < ApplicationController
  skip_before_action :require_login, except: [:new, :create, :edit, :update, :destroy]
  # Add controller filter once set up
  # before_action :find_product, only: [:show, :edit, :update, :destroy?]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @current_merchant = Merchant.find_by(id: session[:user_id])
    if @current_merchant.nil?
      flash[:warning] = "You need to be logged in to list a product"
      head :not_found
      return
    end
    # creates a product with product params that belongs to the current_merchant
    @product = @current_merchant.products.new(product_params)

    if @product.save # returns true if db insert succeeds
      # Add @product.category to flash messages once category is set up
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
    @product = Product.find_by_id(params[:id])
    if @product.nil?
      redirect_to products_path
    end
  end

  def edit
    @product = Product.find_by_id(params[:id])
    if @product.nil?
      head :not_found
      return
    end
  end

  def update
    if @product.nil?
      head :not_found
      return
    elsif @product.update(product_params)
      # Add @product.category to flash messages once category is set up
      flash[:success] = "Your #{@product.name} has been added updated"
      redirect_to product_path(@product.id)
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

    @product= Product.find_by_id(params[:id])
    @product.destroy
    flash[:success] = "Your product listing #{@product.name} has now been deleted"
    redirect_to products_path
    return
  end

  private

  # Do I need merchant_id in strong params?
  def product_params
    return params.require(:product).permit(:name, :description, :price, :photo_url, :stock, category_ids: [])
  end

  # def find_product
  #   Add controller filter
  # end

end
