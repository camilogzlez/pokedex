class AddTypeIdToPokemons < ActiveRecord::Migration[6.1]
  def change
    add_reference :pokemons, :type, null: false, foreign_key: true
  end
end
