Rails.application.routes.draw do
  root "home#index"

  devise_for :users

  resources :addresses

  resources :products
  delete "/products/:id/remove-image", to: "products#remove_image"

  resources :categories do
    resources :products
  end

  # resources :carts, only: [:show] do
  #   member do
  #     post 'add_product_to_cart'
  #   end
  # end

  get "/cart", to: "carts#show_cart"
  post "/cart/:product_id", to: "carts#add_product_to_cart"
  delete "/cart/:product_id", to: "carts#delete_product_from_cart"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
