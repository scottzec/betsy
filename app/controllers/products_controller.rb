class ProductsController < ApplicationController

  # Add controller filter once set up
  # before_action :find_product, only: [:show, :edit, :update, :destroy?]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save # returns true if db insert succeeds
      # Add @product.category to flash messages once category is set up
      flash[:success] = "Your #{@product.name} has been added successfully to the catalog"
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:error] = "Something's gone awry. Your listing hasn't been created"
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
    # Do we want a delete? It doesn't mention delete
    # Only: Retire a product from being sold, which hides it from browsing
    # I noted a custom method for this. Not sure about delete
  end

  private

  # Do I need merchant_id in strong params?
  def product_params
    return params.require(:product).permit(:name, :description, :price, :photo_url, :stock)
  end

  # def find_product
  #   Add controller filter
  # end

end
