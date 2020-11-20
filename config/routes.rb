Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'products#index'
  resources :merchants
  resources :products do
    resources :reviews
  end
  get "/cart", to: "orders#cart", as: "cart"
  get "/orders/:id/merchant_show", to: "orders#merchant_show", as: "merchant_show"

  resources :orders

end
