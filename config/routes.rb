Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'products#index'
  resources :merchants
  resources :products do
    resources :reviews
  end
  resources :orders

  # OAuth routes for merchant authentication
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create"
  delete "/logout", to: "users#destroy", as: "logout"
  # route for merchant dashbaord
  get "/dashboard", to: "merchants#dashboard", as: "dashboard"
end
