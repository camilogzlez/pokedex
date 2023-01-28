class PokemonsController < ApplicationController

  require 'rest-client'

  def index
    conn = Faraday.new("https://pokeapi.co")
    response = conn.get("/api/v2/pokemon/")
    @pokemon = JSON.parse(response.body, symbolize_names: true)
    @pokemons = @pokemon.values[3]
    @pokemons_total = []
    

    @pokemons.each do |pokemon|
      response_2 = Faraday.get(pokemon.values[1])
     @pokemon_2 = JSON.parse(response_2.body, symbolize_names: true)
      @pokemons_total << @pokemon_2
    end 

    #byebug
  

  end

end
