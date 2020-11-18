class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    if @merchant.nil?
      flash[:error] = "Sorry, merchant not found -- Check out our current merchants below!"
      redirect_back fallback_location: merchants_path
    else
      @orderitems = @merchant.orderitems
    end
  end

  # the new function is now handled by GitHub via OAuth. We will only need a create.
  def create
    auth_hash = request.env["omniauth.auth"]
    @merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if @merchant
      # User was found in the database
      flash[:success] = "Logged in as returning user #{@merchant.username}"
    else
      @merchant = Merchant.build_from_github(auth_hash)

      if @merchant.save
        flash[:success] = "Welcome, #{@merchant.username}! Check out your dashboard below to edit your username and email."
      else
        flash[:error] = "Could not create new merchant: #{@merchant.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:user_id] = @merchant.id
    redirect_to dashboard_path
  end

  def destroy
    # require login
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"
    redirect_to root_path
  end


  def edit
    # require login
  end

  def update
    # require login
    # can only update own username
  end

  def dashboard
    # require login
    # needs to verify user id = session id
  end
end
