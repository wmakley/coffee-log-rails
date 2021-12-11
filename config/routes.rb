# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "logs#index"

  resources :logs, only: [:index, :show, :destroy] do
    resources :entries, controller: 'log_entries'
  end

  namespace :coffee_search_form, module: nil, controller: 'coffee_search_form' do
    get :search_results
    get :select_coffee
  end

  resources :coffees do
    resource :photo, controller: 'coffee_photos', only: [:show, :create, :destroy]
  end

  resources :coffee_brands do
    resource :logo, controller: 'coffee_brand_logos', only: [:show, :destroy]
  end

  resource :my_account, controller: 'my_account', only: [:show, :edit, :update]

  resources :users
end
