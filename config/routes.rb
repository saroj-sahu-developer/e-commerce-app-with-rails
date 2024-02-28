Rails.application.routes.draw do
  root "home#index"

  devise_for :users

  resources :addresses
  patch "/users/:id/:address_id", to: "addresses#set_default_address"

  resources :products do
    member do
      delete 'remove_image/:image_id', to: 'products#remove_image', as: :remove_image
    end
  end

  resources :categories do
    resources :products
  end

  get "/cart", to: "carts#show_cart"
  post "/cart/:product_id", to: "carts#add_product_to_cart"
  delete "/cart/:product_id", to: "carts#delete_product_from_cart"

  get "/checkout", to: "checkout#show"

  resources :orders, except: :edit do
    collection do
      get 'bulk_edit'
      patch 'bulk_update'
      get 'get_status_options_for_orders'
    end
  end

  # get "orders/edit", to: "orders#edit"

  # resources :carts, only: [:show] do
  #   member do
  #     post 'add_product_to_cart'
  #   end
  # end



  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
