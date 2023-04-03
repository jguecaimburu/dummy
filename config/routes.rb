# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  root to: redirect(path: "/users")

  resources :users do
    resource :billing_detail, only: [:show], controller: "users/billing_details"
    resources :occupations, only: %i[show new create edit update], controller: "users/occupations"
    resources :banks, only: %i[show new create edit update], controller: "users/banks"
    resources :addresses, only: %i[show new create edit update], controller: "users/addresses"

    collection do
      resources :bulk_trashes, only: %i[create], controller: "users/bulk_trashes", as: "user_bulk_trashes"
    end
  end
end
