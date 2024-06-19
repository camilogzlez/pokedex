class CreatePokemons < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.string :description
      t.integer :weight
      t.string :next_evolution

      t.timestamps
    end
  end
end
