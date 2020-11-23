class MerchantsController < ApplicationController
  skip_before_action :require_login, except: [:dashboard, :edit, :update]
  before_action :edit_merchant_auth, only: [:edit, :update]
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    if @merchant.nil?
      flash[:warning] = "sorry, merchant not found -- check out our current merchants below!"
      redirect_to merchants_path
    else
      @products = @merchant.products
    end
  end

  # the new function is now handled by GitHub via OAuth. We will only need a create.
  def create
    auth_hash = request.env["omniauth.auth"]
    @merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if @merchant
      # merchant was found in the database
      flash[:success] = "Logged in as returning user #{@merchant.username}"
    else
      @merchant = Merchant.build_from_github(auth_hash)

      if @merchant.save

        flash[:success] = "Welcome, #{@merchant.username}! Check out your dashboard below to edit your username and email."
      else
        flash[:warning] = "Could not create new merchant:"
        flash[:error]= @merchant.errors.messages
        return redirect_to root_path
      end

    end

    session[:user_id] = @merchant.id
    # return redirect_to root_path # in case something goes horribly wrong
    return redirect_to dashboard_path
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "successfully logged out!"
    redirect_to root_path
  end


  def edit
    # to go to edit page
  end

  def update
    if @current_merchant.update(merchant_params)
      flash[:success] = "successfully updated merchant info!"
      redirect_to dashboard_path
      return
    else
      flash.now[:warning] = "a problem occurred: could not update merchant info."
      flash[:error] = @current_merchant.errors.messages
      render :edit, status: :bad_request
      return
    end
  end

  # equivalent to current_user in ada books
  def dashboard
    # might need to do something here for filter table later
    @orders = @current_merchant.get_orders(status: params[:sort])
  end

  private

  def merchant_params
    return params.require(:merchant).permit(:username, :email)
  end

  def edit_merchant_auth
    if @current_merchant != Merchant.find_by(id: params[:id])
      flash[:warning] = "invalid merchant or unauthorized access: you must be logged into your own account to edit your info."
      redirect_to dashboard_path
      return
    end
  end
end
