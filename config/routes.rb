Rails.application.routes.draw do
  # Devise customer & admin authentication
  devise_for :users, skip: [:registrations] # or full devise routes

  # Anti-Gravity Cloud Health Checks
  get "up" => "rails/health#show", as: :rails_health_check

  # Storefront & Buna Cultural Showcase
  root "store#index"
  get "ceremony", to: "store#about", as: :ceremony_guide

  # Product Catalog & Filtering
  resources :products, only: [:index, :show]

  # Interactive Hotwire Turbo Cart
  resource :cart, only: [:show] do
    post :add
    patch :update
    delete :remove
    delete :clear
  end
  post "cart/add", to: "carts#add", as: :cart_add
  delete "cart/remove", to: "carts#remove", as: :cart_remove
  delete "cart/clear", to: "carts#clear", as: :cart_clear

  # Kenyan M-Pesa Checkout Flow
  get "checkout", to: "checkouts#new", as: :new_checkout
  post "checkout", to: "checkouts#create", as: :checkout

  # Order Status & Cross-Border Logistics Tracking
  resources :orders, only: [:show] do
    member do
      get :status
      post :retry_stk
      get :track
    end
  end

  # Multi-Currency Switcher (KES / ETB)
  post "currencies/switch", to: "currencies#switch", as: :switch_currency

  # Admin Operations Dashboard
  namespace :admin do
    root to: "dashboard#index"
    resources :orders, only: [:index, :show]
    resources :shipments, only: [:index, :show] do
      member do
        post :update_status
      end
    end
  end

  # Safaricom M-Pesa Daraja API & Logistics Webhooks
  namespace :api do
    namespace :v1 do
      # M-Pesa Express & C2B
      post "mpesa/callback", to: "mpesa#callback"
      post "mpesa/c2b_validation", to: "mpesa#c2b_validation"
      post "mpesa/c2b_confirmation", to: "mpesa#c2b_confirmation"
      post "mpesa/stk_push", to: "mpesa#stk_push"
      get "mpesa/query", to: "mpesa#query"

      # Health check
      get "health", to: "health#show"
    end
  end
end
