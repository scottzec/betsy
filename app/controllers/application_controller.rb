class ApplicationController < ActionController::Base
  # UNCOMMENT FOR OAUTH
  # before_action :require_login

  # def current_merchant
  #   @current_merchant = Merchant.find(session[:user_id])
  # end
  #
  # def require_login
  #   if @current_merchant.nil?
  #     flash[:error] = "You must be logged in to view this section"
  #     redirect_back fallback_location: root_path
  #   end
  # end
end
