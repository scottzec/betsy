class MerchantsController < ApplicationController
  # UNCOMMENT FOR OAUTH
  # skip_before_action :require_login, except: [:dashboard, :edit, :update]

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

  # REPLACE BELOW WITH SOME WORKING VERSION OF THE COMMENTED OUT CODE
  # need to add migration before OAuth can be used
  def login_form
    @current_merchant = Merchant.new
  end

  def login
    username = params[:merchant][:username]
    email = params[:merchant][:email]
    @current_merchant = Merchant.find_by(username: username)

    # since we're entering two fields, we need to check both
    # once we add validations, this needs to be refactored to account for that
    if @current_merchant && email = @current_merchant.email
      session[:user_id] = @current_merchant.id
      flash[:success] = "successfully logged in as existing user #{username}"
    else
      @current_merchant = Merchant.create(username: username, email: email)

      if @current_merchant.valid?
        session[:user_id] = @current_merchant.id
        flash[:success] = "successfully created new merchant #{username} with ID #{@current_merchant.id}"
      else
        flash.now[:warning] = "a problem occurred: could not log in. check that you entered the correct credentials."
        render :login_form, status: :bad_request
        return
      end
    end

    redirect_to dashboard_path
    return
  end
  # REPLACE ABOVE WITH SOME WORKING VERSION OF THE COMMENTED OUT CODE
  # # the new function is now handled by GitHub via OAuth. We will only need a create.
  # def create
  #   auth_hash = request.env["omniauth.auth"]
  #   @merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
  #   if @merchant
  #     # User was found in the database
  #     flash[:success] = "Logged in as returning user #{@merchant.username}"
  #   else
  #     @merchant = Merchant.build_from_github(auth_hash)
  #
  #     if @merchant.save
  #       flash[:success] = "Welcome, #{@merchant.username}! Check out your dashboard below to edit your username and email."
  #     else
  #       flash[:warning] = "Could not create new merchant: #{@merchant.errors.messages}"
  #       return redirect_to root_path
  #     end
  #   end
  #
  #   session[:user_id] = @merchant.id
  #   redirect_to dashboard_path
  # end

  def destroy
    session[:user_id] = nil
    flash[:success] = "successfully logged out!"
    # redirect_to root_path <-- will replace this after merging ProductsController
    redirect_to merchants_path
  end


  def edit
    # redundant after OAuth
    @current_merchant = Merchant.find_by(id: session[:user_id])
    if @current_merchant.nil?
      flash.now[:warning] = "you must be logged in to edit your info."
      # redirect_back fallback_location: root_path <-- will replace this after merging ProductsController
      redirect_to merchants_path
    end
  end

  def update
    # redundant after OAuth
    @current_merchant = Merchant.find_by(id: session[:user_id])
    if @current_merchant.update(merchant_params)
      flash[:success] = "successfully updated merchant info!"
      redirect_to dashboard_path
      return
    else
      flash.now[:warning] = "a problem occurred: could not update merchant info."
      render :edit, status: :bad_request
      return
    end
  end

  # equivalent to current_user in ada books
  def dashboard
    # redundant after OAuth
    @current_merchant = Merchant.find_by(id: session[:user_id])
    unless @current_merchant
      flash[:warning] = "you must be logged in to see this page."
      # redirect_to root_path <-- will replace this after merging ProductsController
      redirect_to merchants_path
      return
    end
  end

  private

  def merchant_params
    return params.require(:merchant).permit(:username, :email)
  end

end
