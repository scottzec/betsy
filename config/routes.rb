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

end
