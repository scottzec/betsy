Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'products#index'

  resources :merchants do
    resources :products
  end

  resources :products do
      resources :reviews
      resources :orderitem
  end

  resources :orders   # , only: [:show, :edit, :update]

  # for categories
  resources :categories, only: [:index, :show, :new, :create]

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
