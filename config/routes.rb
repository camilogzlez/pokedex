# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pokemons#index'

  resources :pokemons, only: [:show]
  get '/pokemons', to: 'pokemons#index'
end
