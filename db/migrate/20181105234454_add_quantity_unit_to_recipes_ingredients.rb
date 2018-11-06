class AddQuantityUnitToRecipesIngredients < ActiveRecord::Migration[5.2]
  def change
    add_column :recipes_ingredients, :quantity, :integer
    add_column :recipes_ingredients, :unit, :string
  end
end
