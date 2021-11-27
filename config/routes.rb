# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "logs#index"

  resources :logs, only: :index do
    resources :entries, controller: 'log_entries'
  end

  resources :coffee_brands
  resources :coffees do
    resource :photo, controller: 'coffee_photos', only: [:create, :destroy]
  end
end
