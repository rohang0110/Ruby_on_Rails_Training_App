# frozen_string_literal: true

Rails.application.routes.draw do
  resources :restaurants, only: %i[new create index]

  resource :profile, only: %i[edit update]

  apipie

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  get 'homepage', to: 'home#index'
  root to: redirect('/homepage')

  resources :restaurants, only: %i[new create index]

  resource :avatar, only: %i[edit update destroy], controller: 'avatars'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index create show update destroy]
    end
  end
  resources :restaurants, only: [:index] do
    resources :tables, only: [:index], controller: 'restaurant_tables'
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
