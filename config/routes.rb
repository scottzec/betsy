Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'products#index'
  resources :merchants
  resources :products do
    resources :reviews
    resources :orderitems
  end
  resources :orders do
    resources :orderitems
  end
  resources :orderitems

  # OAuth routes for merchant authentication
  # get "/auth/github", as: "github_login"
  # get "/auth/:provider/callback", to: "merchants#create"
  # REPLACE WITH OAUTH ROUTES
  get "/login", to: "merchants#login_form", as: "login"
  post "/login", to: "merchants#login"
  # keep this for OAuth
  delete "/logout", to: "merchants#destroy", as: "logout"
  # route for merchant dashbaord
  get "/dashboard", to: "merchants#dashboard", as: "dashboard"
end
