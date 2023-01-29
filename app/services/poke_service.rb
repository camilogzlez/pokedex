# frozen_string_literal: true

class PokeService
  class << self
    def conn
      Faraday.new('https://pokeapi.co')
    end

    def parse_data(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
