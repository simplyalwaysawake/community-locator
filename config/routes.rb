# frozen_string_literal: true

Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root to: 'home#show'

  get 'home/show'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  get 'location' => 'locations#edit'
  post 'location' => 'locations#create'
  patch 'location' => 'locations#update'
  resolve('Location') { [:location] }

  get 'options' => 'user_options#edit'
  post 'options' => 'user_options#create'
  patch 'options' => 'user_options#update'
  resolve('UserOptions') { [:user_options] }

  get 'community' => 'community#show'
  post 'email_community' => 'community#email_community', as: :email_community

  get 'terms' => 'terms#show'

  get 'contact_us' => 'contact_us#new'
  post 'contact_us' => 'contact_us#create'
end
