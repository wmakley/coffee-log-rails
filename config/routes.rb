# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  if Rails.env.heroku?
    get "/*path", redirect("https://coffee-log.fly.dev", status: 302)
    next
  end

  root to: "sessions#new"

  resource :session, only: [:index, :show, :new, :create, :destroy]
  resource :password_reset_request, only: [:index, :new, :create]
  resource :password, only: [:index, :show, :edit, :update]

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
