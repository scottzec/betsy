class CategoriesController < ApplicationController
  # UNCOMMENT FOR OAUTH
  # skip_before_action :require_login, except: [:index, :show]
  def index
    @cats = Category.all
  end

  def show
    @cat = Category.find_by(id: params[:id])
    if @cat.nil?
      flash[:warning] = "categories not found -- browse our current categories or sign in to create a new one!"
      redirect_to categories_path
    else
      @products = @cat.products
    end
  end

  # CANNOT TEST UNTIL OAUTH
  def new
    # redundant after OAuth
    @current_merchant = Merchant.find_by(id: session[:user_id])
    if @current_merchant.nil?
      flash[:error] = "a problem occurred: you must log in to do that"
      redirect_back fallback_location: root_path
    else
      @cat = Category.new
    end
  end

  # CANNOT TEST UNTIL OAUTH
  def create
    @cat = Category.new(cat_params)
    if @cat.save
      flash[:success] = "successfully created new category #{@cat.name}"
      redirect_to dashboard_path
    else
      render :new, status: :bad_request
    end
    return
  end

  private
  
  def cat_params
    return params.require(:category).permit(:name)
  end
end
