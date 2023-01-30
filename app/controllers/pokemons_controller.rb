# frozen_string_literal: true

require 'will_paginate/array'
class PokemonsController < ApplicationController
  def index
    response = PokeService.conn.get('/api/v2/pokemon/?limit=1279')
    @pokemons = PokeService.parse_data(response)[:results].paginate(page: params[:page], per_page: 20)
    @pokemons_details = []

    @pokemons.each do |pokemon|
      response2 = Faraday.get(pokemon[:url])
      @pokemon2 = PokeService.parse_data(response2)
      @pokemons_details << @pokemon2
    end
  rescue StandardError => e
    logger.info e
    redirect_to pokemons_path, flash: { alert: 'No service at this moment' }
    # byebug
  end

  def show
    pokemon = params[:id]
    #  byebug

    response = PokeService.conn.get("/api/v2/pokemon/#{pokemon}")
    @pokemon = PokeService.parse_data(response)

    response2 = PokeService.conn.get("/api/v2/evolution-chain/#{pokemon}")
    @pokemon_evolutions = PokeService.parse_data(response2)

    response3 = PokeService.conn.get("/api/v2/pokemon-species/#{pokemon}")
    @pokemon_especies = PokeService.parse_data(response3)
  rescue StandardError => e
    logger.info e
    redirect_to pokemons_path,
                flash: { alert: 'No info available about this pokemon, you have been redirected to main page' }
  end
end
