class Ingredient < ActiveRecord::Base
  belongs_to :food
  belongs_to :recipe

  def self.find_or_create_from_rows(recipe, rows = [])
    self.clean_ingredient_rows(rows).each do |ingredient|
      Ingredient.find_or_create_by(
        recipe: recipe,
        food: Food.find_or_create_by_name_case_insensitive(ingredient[:food][:name]),
        quantity: ingredient[:quantity],
        unit: ingredient[:unit]
      )
    end
  end

  def self.clean_ingredient_rows(rows)
    rows.find_all do |ingredient|
      ingredient[:food][:name] != ""
    end
  end
end