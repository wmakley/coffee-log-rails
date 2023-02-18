# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  if Rails.env.heroku?
    root to: redirect("https://coffee-log.willmakley.dev", status: 301)
    get "/*path", to: redirect("https://coffee-log.willmakley.dev", status: 301)
  else
    root to: "auth/sessions#new"
  end

  namespace :auth, path: '' do
    resource :session, only: [:index, :show, :new, :create, :destroy]
    resource :password_reset_request, only: [:index, :new, :create]
    resource :password, only: [:index, :show, :edit, :update]
    resource :signup, only: [:index, :show, :new, :create] do
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
  resources :banned_ips, only: [:index, :show, :destroy]
  resources :exceptions, only: [:index]
end
