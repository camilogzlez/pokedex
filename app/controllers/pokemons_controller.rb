# frozen_string_literal: true

require 'will_paginate/array'
class PokemonsController < ApplicationController
  def index
    response = PokeService.conn.get('/api/v2/pokemon/?limit=1279')
    @pokemons = PokeService.parse_data(response)[:results].paginate(page: params[:page], per_page: 20)
    # @pokemons = @pokemon[:results]
    @pokemons_details = []

    @pokemons.each do |pokemon|
      response2 = Faraday.get(pokemon[:url])
      @pokemon2 = PokeService.parse_data(response2)
      @pokemons_details << @pokemon2
    end
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
  end
end
