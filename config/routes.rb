# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # API controllers
  resources :genres, only: %i[index show]
  resources :titles, only: %i[index show] do
    resources :title_episodes, only: %i[index]
    resources :title_principals, only: %i[index]
  end
  resources :people, only: %i[index show]
  resources :professions, only: %i[index show]
  resources :regions, only: %i[index show]
  resources :languages, only: %i[index show]
end
