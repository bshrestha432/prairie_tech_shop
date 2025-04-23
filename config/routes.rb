Rails.application.routes.draw do
  get "invoices/show"
  get "users/index"
  get "checkout/show"
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_for :admin_users, ActiveAdmin::Devise.config
  get '/users', to: 'users#index'

  ActiveAdmin.routes(self)

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Checkout routes
  get 'checkout', to: 'checkout#show', as: 'checkout'  # Checkout page
  post 'checkout/create_order', to: 'checkout#complete_checkout', as: 'create_order_checkout'  # Finalize checkout

  # Categories routes
  resources :categories, only: [:index, :show]

  # Products routes
  resources :products, only: [:index, :show] do
    member do
      post 'add_to_cart'  # Add product to cart
      get 'remove_from_cart'  # Remove product from cart
    end
  end

  post 'complete_checkout', to: 'checkout#complete_checkout', as: :complete_checkout
  resources :orders, only: [:show]  # This is for the order confirmation page


  # Cart routes
  get 'cart', to: 'products#cart'  # View shopping cart
  post 'cart/update_quantity/:id', to: 'products#update_quantity', as: :update_cart_quantity # Update quantity in cart

  # Contact page route
  get 'contact', to: 'contact_pages#show', as: :contact_page

  # About page route
  get 'about', to: 'about_pages#show', as: :about_page

  # Home route (root path)
  root "home#index"
end
