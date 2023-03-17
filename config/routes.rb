# frozen_string_literal: true

Rails.application.routes.draw do
  resources :github_repositories
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "github_repositories#index"
  post "github_repositories/refresh", to: 'github_repositories#refresh', as: :refresh_repositories
end
