class CreateIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredients do |t|
      t.integer :recipe_id
      t.integer :food_id
      t.string :quantity
      t.string :unit
    end
  end
end
