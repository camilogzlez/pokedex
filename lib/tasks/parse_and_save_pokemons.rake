# lib/tasks/poke_service.rake

namespace :db do
  desc "Reset the database and run PokeService to parse and save Pokemons"
  task reset_and_populate: :environment do
    Rake::Task["db:reset"].invoke

    PokeService.new.parse_and_save_pokemons
    puts "Parsed and created #{Pokemon.count} Pokemons"
  end
end
