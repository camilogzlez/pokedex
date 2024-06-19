class PokeService
  BASE_URL = 'https://pokeapi.co'
  POKEMON_ENDPOINT = '/api/v2/pokemon/?limit=100'
  POKEMON_DETAILS_ENDPOINT = '/api/v2/pokemon/'
  EVOLUTION_CHAIN_ENDPOINT = '/api/v2/evolution-chain/'
  POKEMON_SPECIES_ENDPOINT = '/api/v2/pokemon-species/'

  def conn
    @conn ||= Faraday.new(BASE_URL)
  end

  def parse_data(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def parse_and_save_pokemons
    pokemons = get_all_pokemons
    return unless pokemons

    pokemons.each do |pokemon|
      pokemon_data = get_pokemon_basic_info(pokemon)
      next unless pokemon_data

      pokemon_id = extract_pokemon_id(pokemon)
      pokemon_evolutions = get_pokemon_next_evolution(pokemon_id)
      pokemon_description = get_pokemon_description(pokemon_id)
      types = create_pokemon_types(pokemon_data)
      abilities = create_pokemon_abilities(pokemon_data)
      create_pokemon(pokemon, pokemon_data, pokemon_evolutions, pokemon_description, types, abilities)
    end
  end

  private

  def get_all_pokemons
    response = api_get(POKEMON_ENDPOINT)
    response[:results] if response
  end

  def get_pokemon_basic_info(pokemon)
    api_get("#{POKEMON_DETAILS_ENDPOINT}#{pokemon[:name]}")
  end

  def get_pokemon_next_evolution(pokemon_id)
    api_get("#{EVOLUTION_CHAIN_ENDPOINT}#{pokemon_id}")
  end

  def get_pokemon_description(pokemon_id)
    api_get("#{POKEMON_SPECIES_ENDPOINT}#{pokemon_id}")
  end

  def api_get(endpoint)
    response = conn.get(endpoint)
    parse_data(response) if response.success?
  rescue StandardError => e
    puts "Error fetching data from #{endpoint}: #{e.message}"
    nil
  end

  def extract_pokemon_id(pokemon)
    pokemon[:url].split('/')[-1]
  end

  def create_pokemon_types(pokemon_data)
    pokemon_data[:types].map { |type_data| Type.find_or_create_by(name: type_data[:type][:name]) }
  end

  def create_pokemon_abilities(pokemon_data)
    pokemon_data[:abilities].map { |ability_data| Ability.find_or_create_by(name: ability_data[:ability][:name]) }
  end

  def create_pokemon(pokemon, pokemon_data, pokemon_evolutions, pokemon_description, types, abilities)
    pokemon_record = Pokemon.find_or_create_by(name: pokemon[:name]) do |poke|
      poke.weight = pokemon_data[:weight]
      poke.image_url = pokemon_data[:sprites][:other][:home][:front_default]
      poke.next_evolution = pokemon_evolutions.dig(:chain, :evolves_to, 0, :species, :name)
      poke.description = pokemon_description.dig(:flavor_text_entries, 0, :flavor_text)
    end

    assign_types_to_pokemon(pokemon_record, types)
    assign_abilities_to_pokemon(pokemon_record, abilities)
  end

  def assign_types_to_pokemon(pokemon_record, types)
    types.each do |type|
      pokemon_record.types << type unless pokemon_record.types.include?(type)
    end
  end

  def assign_abilities_to_pokemon(pokemon_record, abilities)
    abilities.each do |ability|
      pokemon_record.abilities << ability unless pokemon_record.abilities.include?(ability)
    end
  end
end


