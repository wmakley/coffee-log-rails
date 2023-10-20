# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  if Rails.env.heroku?
    root to: redirect("https://coffee-log.willmakley.dev", status: 301)
    get "/*path", to: redirect("https://coffee-log.willmakley.dev", status: 301)
  else
    root to: "auth/sessions#new"
  end

  namespace :auth, path: '' do
    resource :session, only: [:show, :new, :create, :destroy]
    resource :password_reset_request, only: [:show, :new, :create]
    resource :password, only: [:show, :edit, :update]
    resource :signup, only: [:show, :new, :create] do
      collection do
        get :success
      end
    end
    resource :email_verification, path: 'email-verification', only: [:show, :new, :create]
  end

  resources :logs, only: [:index, :show, :destroy] do
    resources :entries, controller: 'log_entries'
  end

  namespace :lookup_coffee, module: nil, controller: 'lookup_coffee_form' do
    root to: 'lookup_coffee_form#search_results'
    get :search_results
    get :select_coffee
  end

  resources :coffees do
    collection do
      get :sort
    end
    resource :photo, controller: 'coffee_photos', only: [:show, :create, :destroy]
  end

  resources :coffee_brands do
    resource :logo, controller: 'coffee_brand_logos', only: [:show, :destroy]
  end

  resource :my_account, controller: 'my_account', only: [:show, :edit, :update]

  # Admin-only
  resources :brew_methods
  resources :users
  resources :user_groups, path: 'user-groups', except: [:show] do
    resources :memberships, controller: 'user_group_memberships', only: [:index, :new, :create, :destroy]
  end
  resources :signup_codes, path: 'signup-codes', except: [:show]
  resources :banned_ips, only: [:index, :show, :destroy]
  resources :exceptions, only: [:index]
end
