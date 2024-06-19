class RemoveTypeIdFromPokemons < ActiveRecord::Migration[6.1]
  def change
    remove_column :pokemons, :type_id, :bigint
  end
end
