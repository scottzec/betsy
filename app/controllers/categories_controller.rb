class CategoriesController < ApplicationController
  skip_before_action :require_login, except: [:new, :create]
  def index
    @cats = Category.all
  end

  def show
    @cat = Category.find_by(id: params[:id])
    if @cat.nil?
      flash[:warning] = "category not found -- browse our current categories or sign in to create a new one!"
      redirect_to categories_path
    else
      @products = @cat.products
    end
  end

  # CANNOT TEST UNTIL OAUTH
  def new
    @cat = Category.new
  end

  # CANNOT TEST UNTIL OAUTH
  def create
    @cat = Category.new(cat_params)
    if @cat.save
      flash[:success] = "successfully created new category #{@cat.name}."
      redirect_to dashboard_path
    else
      flash[:error] = @cat.errors.messages
      render :new, status: :bad_request
    end
    return
  end

  private

  def cat_params
    return params.require(:category).permit(:name)
  end
end
