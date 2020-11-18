class MerchantsController < ApplicationController
  def create
    auth_hash = request.env["omniauth.auth"]
    @merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if @merchant
      # User was found in the database
      flash[:success] = "Logged in as returning user #{@merchant.username}"
    else
      @merchant = Merchant.build_from_github(auth_hash)

      if @merchant.save
        flash[:success] = "Welcome, #{@merchant.username}! Check out your dashboard to edit your username and email."
      else
        flash[:error] = "Could not create new merchant: #{@merchant.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:user_id] = @merchant.id
    redirect_to root_path
  end
end
