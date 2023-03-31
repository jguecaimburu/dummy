# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  root to: redirect(path: '/users')

  resources :users do
    resource :billing_detail, only: [:show], controller: "users/billing_details"
    resource :company_detail, only: [:show], controller: "users/company_details"
  end

  resources :addresses
  resources :banks
end
