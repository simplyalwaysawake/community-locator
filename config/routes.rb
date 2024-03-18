# frozen_string_literal: true

Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root to: 'home#show'

  get 'home/show'

  devise_for :users

  get 'location' => 'locations#edit'
  post 'location' => 'locations#create'
  patch 'location' => 'locations#update'
  resolve('Location') { [:location] }

  get 'community' => 'community#show'
end
