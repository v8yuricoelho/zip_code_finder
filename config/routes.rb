# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root 'zip_codes#index'

  get '/zip_codes/:zip_code', to: 'zip_codes#show', as: 'zip_code'
end
